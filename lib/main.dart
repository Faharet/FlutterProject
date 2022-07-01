import 'package:flutter/material.dart';
import 'process_monitor.dart' as pm;
import 'package:timer_builder/timer_builder.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'the Salomé Beta v0.1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'the Salomé Beta v0.1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool diskpartOnline = false;
  bool acronisOnline = false;
  String log = 'This is log file';
  String diskpartlog = "This is a diskpart log";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(title: Text(Directory.current.path),);
                  });
                },
                child: const Text('BatEventByProcess'),
              ),]
          ),
          Center(
            child: TimerBuilder.periodic(const Duration(seconds: 1), builder: (context){
              diskpartStatus();
              diskpartlog = pm.getDisks();
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0), 
                    child: Text(
                      log, 
                      style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0), 
                    child: Text(
                      diskpartlog, 
                      style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),),),
                ]
              );
        },)),
        ],
      ),
    );
  }

  void diskpartStatus(){
    acronisOnline = pm.findProc();
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
  }
}
