import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String string = "Change time in ini file";
  String log = 'This is log file';
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
                  var result = await Process.run(
                      'E:\\flutterfiles\\lib\\BatbyProcess.bat', [],
                      runInShell: true);
                  setState(() => log = result.stdout + result.stderr);
                },
                child: const Text('BatEventByProcess'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Process.run(
                      'E:\\flutterfiles\\lib\\BatEvent.bat', [],
                      runInShell: true);
                  setState(() => log = result.stdout + result.stderr);
                },
                child: const Text('BatEventByTime'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Process.run(
                      'E:\\flutterfiles\\lib\\BatEventDelete.bat', [],
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
              Text(
                  "${_selectedTimeStart.hour ~/ 10}${_selectedTimeStart.hour % 10}:${_selectedTimeStart.minute ~/ 10}${_selectedTimeStart.minute % 10}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, 2);
                },
                child: const Text("Choose End time"),
              ),
              Text(
                  "${_selectedTimeEnd.hour ~/ 10}${_selectedTimeEnd.hour % 10}:${_selectedTimeEnd.minute ~/ 10}${_selectedTimeEnd.minute % 10}"),
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
        ],
      ),
    );
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
        const filename = 'E:\\flutterfiles\\lib\\configTimeStart.ini';
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
        const filename = 'E:\\flutterfiles\\lib\\configTimeEnd.ini';
        var file = await File(filename).writeAsString(
            'mytime=${_selectedTimeEnd.hour ~/ 10}${_selectedTimeEnd.hour % 10}:${_selectedTimeEnd.minute ~/ 10}${_selectedTimeEnd.minute % 10}');
        break;
    }
  }
}
