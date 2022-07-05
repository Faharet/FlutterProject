import 'dart:ffi' as ffi;
import 'dart:io' show Directory, Process;
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

typedef MediaNative = ffi.Int Function(ffi.Pointer<pffi.Utf8> media);
typedef Media = int Function(ffi.Pointer<pffi.Utf8> media);

final Media ejectMedia = cppLibsDll.lookupFunction<MediaNative, Media>('ejectMedia');
int eject(String media){
  var buffer = ejectMedia(media.toNativeUtf8());
  return buffer;
}

final Media loadMedia = cppLibsDll.lookupFunction<MediaNative, Media>('loadMedia');
int load(String media){
  var buffer = loadMedia(media.toNativeUtf8());
  return buffer;
}

List<String> getButtons(){
  String diskpartlog = "This is a diskpart log";
  diskpartlog = getDisks();
  final List<String> elements = [];
  int i = 0;
  while(i < diskpartlog.length){
    elements.add(diskpartlog[i] + diskpartlog[i+1] + diskpartlog[i+2]);
    i = i + 3;
  }
  return elements;
}

String diskpartStatus(){
    String log = "This is a log file";
    bool diskpartOnline = false;
    bool acronisOnline = false;
    acronisOnline = findProc();
    if(acronisOnline && !diskpartOnline){
      Process.run("mspaint.exe", []);
      diskpartOnline = true;
      log = "Acronis online, Diskpart offline";
    }
    if(acronisOnline && diskpartOnline){
      diskpartOnline = true;
      log = "Acronis online, Diskpart online";
    }
    if(!acronisOnline && diskpartOnline){
      Process.run("calc.exe", []);
      diskpartOnline = false;
      log = "Acronis offline, Diskpart offline";
    }
    if(!acronisOnline && !diskpartOnline){
      log = "Acronis offline, Diskpart offline";
    }
    return log;    
  }