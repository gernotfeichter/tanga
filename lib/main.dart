import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tang/server.dart';

const int defaultPort = 7500;
const int defaultTimeoutMinutes = 2;

void main() {
  runApp(const TangaApp());
}

class TangaApp extends StatelessWidget {
  const TangaApp({super.key, this.autoStart = true});

  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tanga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TangHomePage(title: 'tang server', autoStart: autoStart),
    );
  }
}

class TangHomePage extends StatefulWidget {
  const TangHomePage({
    super.key,
    required this.title,
    this.autoStart = true,
  });

  final String title;
  final bool autoStart;

  @override
  State<TangHomePage> createState() => _TangHomePageState();
}

class _TangHomePageState extends State<TangHomePage> {
  static const _portKey = 'port';
  static const _timeoutKey = 'timeoutMinutes';

  final _portController = TextEditingController(text: '$defaultPort');
  final _timeoutController = TextEditingController(
    text: '$defaultTimeoutMinutes',
  );

  TangServer? _server;
  bool _busy = true;
  String _status = 'starting...';
  List<String> _addresses = const [];

  Timer? _stopTimer;
  Timer? _tickTimer;
  DateTime? _stopAt;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadSettings();
    if (widget.autoStart) {
      await _start();
    } else {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'stopped';
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final port = prefs.getInt(_portKey) ?? defaultPort;
    final timeout = prefs.getInt(_timeoutKey) ?? defaultTimeoutMinutes;
    if (!mounted) return;
    setState(() {
      _portController.text = '$port';
      _timeoutController.text = '$timeout';
    });
    _portController.addListener(_persistSettings);
    _timeoutController.addListener(_persistSettings);
  }

  void _persistSettings() {
    _saveSettings(_port, _timeoutMinutes);
  }

  Future<void> _saveSettings(int port, int timeout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_portKey, port);
    await prefs.setInt(_timeoutKey, timeout);
  }

  int get _port => int.tryParse(_portController.text.trim()) ?? defaultPort;

  int get _timeoutMinutes =>
      int.tryParse(_timeoutController.text.trim()) ?? defaultTimeoutMinutes;

  Future<void> _start() async {
    if (_server?.isRunning ?? false) return;
    final port = _port;
    final timeout = _timeoutMinutes;
    setState(() {
      _busy = true;
      _status = 'starting...';
    });
    await _saveSettings(port, timeout);
    try {
      final server = TangServer.generate();
      await server.start(port: port);
      final addresses = await _localAddresses();
      if (!mounted) {
        await server.stop();
        return;
      }
      setState(() {
        _server = server;
        _addresses = addresses;
        _status = 'running';
        _busy = false;
      });
      _scheduleAutoStop(timeout);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _status = 'failed to start: $error';
        _busy = false;
      });
    }
  }

  Future<void> _stop() async {
    _cancelTimers();
    final server = _server;
    if (server == null) {
      if (!mounted) return;
      setState(() {
        _addresses = const [];
        _status = 'stopped';
        _busy = false;
      });
      return;
    }
    setState(() {
      _busy = true;
      _status = 'stopping...';
    });
    _server = null;
    await server.stop();
    if (!mounted) return;
    setState(() {
      _addresses = const [];
      _status = 'stopped';
      _busy = false;
    });
  }

  Future<List<String>> _localAddresses() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
    );
    return [
      for (final interface in interfaces)
        for (final address in interface.addresses) address.address,
    ];
  }

  void _scheduleAutoStop(int timeoutMinutes) {
    _cancelTimers();
    if (timeoutMinutes <= 0) return;
    final duration = Duration(minutes: timeoutMinutes);
    _stopAt = DateTime.now().add(duration);
    _stopTimer = Timer(duration, _stop);
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _cancelTimers() {
    _stopTimer?.cancel();
    _stopTimer = null;
    _tickTimer?.cancel();
    _tickTimer = null;
    _stopAt = null;
  }

  @override
  void dispose() {
    _portController.removeListener(_persistSettings);
    _timeoutController.removeListener(_persistSettings);
    _portController.dispose();
    _timeoutController.dispose();
    _cancelTimers();
    _server?.stop();
    super.dispose();
  }

  String _formatRemaining() {
    final stopAt = _stopAt;
    if (stopAt == null) return '';
    var remaining = stopAt.difference(DateTime.now());
    if (remaining.isNegative) remaining = Duration.zero;
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final running = _server?.isRunning ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(running ? Icons.lock_open : Icons.lock, size: 72),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'status: $_status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (running && _stopAt != null) ...[
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'auto-stop in ${_formatRemaining()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 24),
            _settingsCard(context, enabled: !running && !_busy),
            const SizedBox(height: 24),
            if (running) ..._runningDetails(context),
            const SizedBox(height: 24),
            running
                ? FilledButton.icon(
                    onPressed: _busy ? null : _stop,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop tang server'),
                  )
                : FilledButton.icon(
                    onPressed: _busy ? null : _start,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start tang server'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, {required bool enabled}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              enabled: enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeoutController,
              enabled: enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Auto-stop after (minutes)',
                helperText: '0 = never stop (forever)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _runningDetails(BuildContext context) {
    final port = _server?.port ?? _port;
    if (_addresses.isEmpty) {
      return [
        Center(
          child: Text(
            'port: $port',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        const Center(child: Text('no network address found')),
      ];
    }
    final example = _addresses.first;
    return [
      Center(
        child: Text(
          'port: $port',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      const SizedBox(height: 8),
      for (final address in _addresses)
        Center(
          child: Text(
            'http://$address:$port',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      const SizedBox(height: 8),
      Text(
        'Bind a LUKS volume with:\n'
        'clevis luks bind -d <dev> tang '
        '{"url":"http://$example:$port"}',
        textAlign: TextAlign.center,
      ),
    ];
  }
}
