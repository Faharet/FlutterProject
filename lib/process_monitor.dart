import 'dart:ffi' as ffi;
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart' as pffi;

var cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll');
//var cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');
final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();

final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc'); 
bool findProc(){
  return find();
}

typedef GetDisksNative = ffi.Pointer<pffi.Utf8> Function();
typedef GetDisks = ffi.Pointer<pffi.Utf8> Function();

final GetDisks get = cppLibsDll.lookupFunction<GetDisksNative, GetDisks>('getDisks');
String getDisks(){
  var buffer = get();
  return buffer.toDartString();
}