import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;

class Drive extends ffi.Struct{
  external ffi.Pointer<pffi.Utf8> letter;
  external ffi.Pointer<pffi.Utf8> label;
}

typedef GetLetterNative = Drive Function(ffi.Int i);
typedef GetLetter =  Drive Function(int i);
typedef GetLengthNative = ffi.Int Function();
typedef GetLength =  int Function();
typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Bool Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = bool Function(ffi.Pointer<pffi.Utf8> media, bool signal);

final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
//final var cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');

final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class Controller{
  String processLog = "Process log";
  List<Drive> drives = [];
  Controller();

  void getButtons(){
    int length = getLength();
    for(int i = 0; i < length*4; i += 4){
      drives.add(getLetter(i));
    }
  }

  void getProcessLog(String button){
    bool mediaResult = false;
    bool acronisOnline = false;
    acronisOnline = findProc();
    drives.clear();
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

  final GetLetter getletter = cppLibsDll.lookupFunction<GetLetterNative, GetLetter>('getLetter');
  Drive getLetter(int i){
    var buffer = getletter(i);
    return buffer;
  }

  final GetLength getlength = cppLibsDll.lookupFunction<GetLengthNative, GetLength>('getLength');
  int getLength(){
    var buffer = getlength();
    return buffer;
  }
}