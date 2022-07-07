import 'dart:ffi' as ffi;
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart' as pffi;

typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef GetDisksNative = ffi.Pointer<pffi.Utf8> Function();
typedef GetDisks = ffi.Pointer<pffi.Utf8> Function();
typedef MediaNative = ffi.Void Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = void Function(ffi.Pointer<pffi.Utf8> media, bool signal);

final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
//final var cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');

final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class ViewController{
  String processLog = "Process log";
  String diskButtons = "Disk log";
  List<String> elements = [];
  late String button;
  ViewController(){
    getButtons();
    getProcessLog();
  }


  void getButtons(){
    diskButtons = getDisks();
    int i = 0;
    while(i < diskButtons.length){ // ?
      elements.add(diskButtons[i]);
      i = i + 3;
    }
  } 

  void setButtonName(String button){
    this.button = button;
  }

  void getProcessLog(){
    bool diskpartOnline = false;
    bool acronisOnline = false;
    acronisOnline = findProc();
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
      processLog = "Acronis offline, Diskpart offline";
    } 
  }

  final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc(){
    return find();
  }

  final GetDisks get = cppLibsDll.lookupFunction<GetDisksNative, GetDisks>('getDisks');
  String getDisks(){
    var buffer = get();
    return buffer.toDartString();
  }

  final Media manage = cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  void manageMedia(String media, bool signal){
    manage(media.toNativeUtf8(), signal);
  }
}
