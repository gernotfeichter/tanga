import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'tang/server.dart';

void main() {
  runApp(const TangaApp());
}

class TangaApp extends StatelessWidget {
  const TangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tanga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TangHomePage(title: 'tanga - tang server'),
    );
  }
}

class TangHomePage extends StatefulWidget {
  const TangHomePage({super.key, required this.title});

  final String title;

  @override
  State<TangHomePage> createState() => _TangHomePageState();
}

class _TangHomePageState extends State<TangHomePage> {
  static const int _port = 7500;

  TangServer? _server;
  bool _busy = false;
  String _status = 'stopped';
  List<String> _addresses = const [];

  Future<void> _start() async {
    setState(() {
      _busy = true;
      _status = 'starting...';
    });
    try {
      final server = TangServer.generate();
      await server.start(port: _port);
      final interfaces = await NetworkInterface.list(
        includeLinkLocal: false,
        type: InternetAddressType.IPv4,
      );
      setState(() {
        _server = server;
        _addresses = [
          for (final interface in interfaces)
            for (final address in interface.addresses) address.address,
        ];
        _status = 'running';
        _busy = false;
      });
    } catch (error) {
      setState(() {
        _status = 'failed to start: $error';
        _busy = false;
      });
    }
  }

  Future<void> _stop() async {
    setState(() {
      _busy = true;
      _status = 'stopping...';
    });
    final server = _server;
    _server = null;
    await server?.stop();
    if (!mounted) return;
    setState(() {
      _addresses = const [];
      _status = 'stopped';
      _busy = false;
    });
  }

  @override
  void dispose() {
    _server?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = _server?.isRunning ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(running ? Icons.lock_open : Icons.lock, size: 72),
              const SizedBox(height: 16),
              Text(
                'status: $_status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (running) ...[
                Text(
                  'port: $_port',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                for (final address in _addresses)
                  Text(
                    'http://$address:$_port',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Bind a LUKS volume with:\n'
                  'clevis luks bind -d <dev> tang '
                  '{"url":"http://<address above>:$_port"}',
                  textAlign: TextAlign.center,
                ),
              ],
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
      ),
    );
  }
}
