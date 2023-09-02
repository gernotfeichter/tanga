import 'package:ffi/ffi.dart';
import "generated_bindings.dart";
import 'package:path/path.dart' as path;
import 'dart:io' show Directory;
import 'dart:ffi' as ffi;

Future<int> main(List<String> args) {
  
  var libraryPath = path.join(Directory.current.path, 'src', 'build', 'cmd', 'libjose.so');

  final dynlib = ffi.DynamicLibrary.open(libraryPath);

  final nativeLib = NativeLibrary(dynlib);

  // Convert the Dart strings to pointers to C strings.
  final utf8Ptrs = args.map((String str) {
    return str.toNativeUtf8();
  }).toList();

  // Allocate an array of pointers to FFI `ffi.Char` values.
  final argsCStringArray = malloc.allocate<ffi.Pointer<ffi.Char>>(utf8Ptrs.length);

  // Populate the array with the pointers to the C strings.
  for (var i = 0; i < utf8Ptrs.length; i++) {
    argsCStringArray[i] = utf8Ptrs[i].cast<ffi.Char>();
  }

  // Call the C function.
  return nativeLib.main(utf8Ptrs.length, argsCStringArray);
}
