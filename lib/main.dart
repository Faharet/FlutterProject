import 'dart:async';
import 'dart:ffi' as ffi;
import 'package:flutter/material.dart';
import 'dart:io';
import 'process_monitor.dart' as pm;

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
  String log = 'This is log file';
  String logStream = '';
  final controller = StreamController<List<int>>();
  final myController = TextEditingController();
  TimeOfDay _selectedTimeStart = TimeOfDay.now();
  TimeOfDay _selectedTimeEnd = TimeOfDay.now();
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
                  if(pm.findProc() != 0){
                    setState(() {
                      log = "is On";
                    });
                  }
                },
                child: const Text('BatEventByProcess'),
              ),]
          ),
          Center(
            child: Text(
              log,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  backgroundColor: Colors.black),
            ),
          ),
          Center(
            child: Text(
              logStream,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  backgroundColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  myFunc(Stream<List<int>> std) async {
    var controller = new StreamController<List<int>>();
    controller.addStream(std);
    controller.stream.listen((item) => log = item as String);
  }

  _selectTime(BuildContext context, int i) async {
    switch (i) {
      case 1:
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: _selectedTimeStart,
          initialEntryMode: TimePickerEntryMode.dial,
        );
        if (timeOfDay != null && timeOfDay != _selectedTimeStart) {
          setState(() {
            _selectedTimeStart = timeOfDay;
          });
        }
        const filename = '.\\lib\\configTimeStart.ini';
        var file = await File(filename).writeAsString(
            'mytime=${_selectedTimeStart.hour ~/ 10}${_selectedTimeStart.hour % 10}:${_selectedTimeStart.minute ~/ 10}${_selectedTimeStart.minute % 10}');
        break;
      case 2:
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: _selectedTimeEnd,
          initialEntryMode: TimePickerEntryMode.dial,
        );
        if (timeOfDay != null && timeOfDay != _selectedTimeEnd) {
          setState(() {
            _selectedTimeEnd = timeOfDay;
          });
        }
        const filename = '.\\lib\\configTimeEnd.ini';
        var file = await File(filename).writeAsString(
            'mytime=${_selectedTimeEnd.hour ~/ 10}${_selectedTimeEnd.hour % 10}:${_selectedTimeEnd.minute ~/ 10}${_selectedTimeEnd.minute % 10}');
        break;
    }
  }
}
