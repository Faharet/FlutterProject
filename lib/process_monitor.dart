import 'dart:ffi' as ffi;
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;

typedef FindMyProcNative = ffi.Int32 Function();
typedef FindMyProc = int Function();

var libraryPath = path.windows.join(Directory.current.path, 'lib', 'libprocess_monitor', 'libprocess_monitor.dll');
final dylib = ffi.DynamicLibrary.open(libraryPath);

final FindMyProc find = dylib.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc'); 
int findProc(){
  return find();
}