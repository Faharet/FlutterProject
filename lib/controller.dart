import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;

typedef GetDisksNative = ffi.Pointer<pffi.Utf8> Function();
typedef GetDisks = ffi.Pointer<pffi.Utf8> Function();
typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Bool Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = bool Function(ffi.Pointer<pffi.Utf8> media, bool signal);

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
    for(int i = 0; i < diskButtons.length; ++i) {
      elements.add(diskButtons[i]);
    }
  }

  void getProcessLog(String button){
    bool mediaResult = false;
    bool acronisOnline = false;
    acronisOnline = findProc();
    elements.clear();
    if(acronisOnline){
      mediaResult = manageMedia("\\\\.\\$button:", true);
      if(mediaResult) {
        mediaResult = false;
      }
      processLog = "$button ON $mediaResult";
    }
    if(!acronisOnline){
      mediaResult = manageMedia("\\\\.\\$button:", false);
      if(mediaResult){
        mediaResult = false;
      }
      processLog = "$button OFF $mediaResult";
    } 
  }

  final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc(){
    return find();
  }

  final Media manage = cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  bool manageMedia(String media, bool signal){
    return manage(media.toNativeUtf8(), signal);
  }

  final GetDisks get = cppLibsDll.lookupFunction<GetDisksNative, GetDisks>('getDisks');
  String getDisks(){
    var buffer = get();
    return buffer.toDartString();
  }
}