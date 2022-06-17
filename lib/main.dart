import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
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
  String log = 'This is log file';
  String logStream = '';
  var controller;
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
                onPressed: () async {
                  var result = await Process.start(
                      '.\\lib\\BatbyProcess.bat', [],
                      runInShell: true);
                  controller = StreamController<List<int>>();
                  controller.addStream(result.stdout);
                  controller.stream.listen((item) =>
                      setState(() => logStream = String.fromCharCodes(item)));
                },
                child: const Text('BatEventByProcess'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Process.run('.\\lib\\BatEvent.bat', [],
                      runInShell: true);
                  setState(() => log = result.stdout + result.stderr);
                },
                child: const Text('BatEventByTime'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Process.run(
                      '.\\lib\\BatEventDelete.bat', [],
                      runInShell: true);
                  setState(() => log = result.stdout + result.stderr);
                },
                child: const Text('BatEventDelete'),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, 1);
                },
                child: const Text("Choose Start time"),
              ),
              Text("${_selectedTimeStart.hour ~/ 10}${_selectedTimeStart.hour % 10}:" +
                  "${_selectedTimeStart.minute ~/ 10}${_selectedTimeStart.minute % 10}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, 2);
                },
                child: const Text("Choose End time"),
              ),
              Text("${_selectedTimeEnd.hour ~/ 10}${_selectedTimeEnd.hour % 10}:" +
                  "${_selectedTimeEnd.minute ~/ 10}${_selectedTimeEnd.minute % 10}"),
            ],
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

  myFunc(Stream<List<Int>> std) async {
    var controller = new StreamController<List<Int>>();
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
