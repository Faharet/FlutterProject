import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;

typedef GetDisksNative = ffi.Pointer<pffi.Utf8> Function();
typedef GetDisks = ffi.Pointer<pffi.Utf8> Function();
typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Void Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = void Function(ffi.Pointer<pffi.Utf8> media, bool signal);

final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
//final var cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');

final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class Controller{
  String processLog = "Process log";
  String diskButtons = "Disk log";
  List<String> elements = [];
  Controller();

  void getButtons(){
    diskButtons = getDisks();
    int i = 0;
    while(i < diskButtons.length){ // ?
      elements.add(diskButtons[i]);
      i = i + 3;
    }
  }

  void getProcessLog(String button){
    bool diskpartOnline = false;
    bool acronisOnline = false;
    acronisOnline = findProc();
    elements.clear();
    if(acronisOnline && !diskpartOnline){
      manageMedia("\\\\.\\$button:", true);
      diskpartOnline = true;
      processLog = "Acronis online, Diskpart offline";
    }
    if(acronisOnline && diskpartOnline){
      diskpartOnline = true;
      processLog = "Acronis online, Diskpart online";
    }
    if(!acronisOnline && diskpartOnline){
      manageMedia("\\\\.\\$button:", false);
      diskpartOnline = false;
      processLog = "Acronis offline, Diskpart offline";
    }
    if(!acronisOnline && !diskpartOnline){
      manageMedia("\\\\.\\$button:", false);
      processLog = "Acronis offline, Diskpart offline";
    } 
  }

  final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc(){
    return find();
  }

  final Media manage = cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  void manageMedia(String media, bool signal){
    manage(media.toNativeUtf8(), signal);
  }

  final GetDisks get = cppLibsDll.lookupFunction<GetDisksNative, GetDisks>('getDisks');
  String getDisks(){
    var buffer = get();
    return buffer.toDartString();
  }
}

