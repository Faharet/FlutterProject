import 'dart:ffi' as ffi;
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart' as pffi;

typedef GetDisksNative = ffi.Pointer<pffi.Utf8> Function();
typedef GetDisks = ffi.Pointer<pffi.Utf8> Function();

final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
//final var cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');

final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class ViewController{
  String diskButtons = "Disk log";
  List<String> elements = [];
  late String drive;
  ViewController(){
    getButtons();
  }

  void getButtons(){
    diskButtons = getDisks();
    int i = 0;
    while(i < diskButtons.length){ // ?
      elements.add(diskButtons[i]);
      i = i + 3;
    }
  } 

  final GetDisks get = cppLibsDll.lookupFunction<GetDisksNative, GetDisks>('getDisks');
  String getDisks(){
    var buffer = get();
    return buffer.toDartString();
  }
}
