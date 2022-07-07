import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'dart:io' show Directory;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;
import 'package:path/path.dart' as path;

typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Void Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = void Function(ffi.Pointer<pffi.Utf8> media, bool signal);

final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class DriveController extends StatefulWidget{
  late String button;
  DriveController({super.key, required String b}){
    button = b;
  }

  @override
  State<StatefulWidget> createState() => DriveControllerState();
}

class DriveControllerState extends State<DriveController>{
  String processLog = "Process log";
  @override
  Widget build(BuildContext context){
    String button = widget.button;
    return TimerBuilder.periodic(
      const Duration(seconds: 1), 
      builder: (context) {
        getProcessLog(button);
        return Center(
          child: Text(processLog)
        ); 
      },
    );
  }

  final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc(){
    return find();
  }

  final Media manage = cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  void manageMedia(String media, bool signal){
    manage(media.toNativeUtf8(), signal);
  }

  void getProcessLog(String button){
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
      manageMedia("\\\\.\\$button:", false);
      processLog = "Acronis offline, Diskpart offline";
    } 
  }

}