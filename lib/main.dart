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
  List<String> elements = [];
  @override
  Widget build(BuildContext context) {
    elements = pm.getButtons();
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
                  showDialog(
                    context: context, 
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(Directory.current.path),
                      );
                    }
                  );
                },
                child: const Text('BatEventByProcess'),
              ),
            ]
          ),
          Center(
            child: TimerBuilder.periodic(
              const Duration(seconds: 1), 
              builder: (context){
                diskpartStatus();
                return Column(
                  children: <Widget>[
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: elements.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 35.0, 
                        crossAxisSpacing: 20.0, 
                        mainAxisSpacing: 20.0),
                      itemBuilder: (context, i){
                        return Card(
                          
                          child: OutlinedButton(
                            onPressed: () => print(elements[i]), 
                            child: const SizedBox(
                              child: Text("Button"),
                              width: 20.0,
                              height: 20.0,
                            ),
                          ),
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0), 
                      child: Text(
                        log, style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),
                      ),
                    ),
                  ]
                );
              },
            )
          ),
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
