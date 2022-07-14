import 'package:flutter/material.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  final String title = "Calendar";

  @override
  State<CalendarPage> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController diskController = TextEditingController();
  TextEditingController backupController = TextEditingController();
  late String diskToBackup = "not set";
  late String backupToDisk = "not set";
  late TimeOfDay time = TimeOfDay.now();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            TableCalendar(
              focusedDay: DateTime.now(), 
              firstDay: DateTime.now(), 
              lastDay: DateTime.utc(2023),
              onDaySelected: (selectedDay, focusedDay){
                showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return Form(
                      key: formkey,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: diskController,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "Must be filled";
                                }
                                RegExp reg = RegExp("^[A-Z]:");
                                if(!value.contains(reg)){
                                  return "Usage: {[letter]:}"; 
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: backupController,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "Must be filled";
                                }
                                RegExp reg = RegExp("^[A-Z]:");
                                if(!value.contains(reg)){
                                  return "Usage: {[letter]:}"; 
                                }
                                return null;
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  selectTime(context);
                                },
                                child: const Text("Set time"),
                              )
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: (){
                                if(formkey.currentState!.validate()){
                                  setState(() {
                                    diskToBackup = diskController.text;
                                    backupToDisk = backupController.text;
                                  });
                                  File("lib\\scripts\\config.ini").writeAsString("wayToFiles=$diskToBackup\nwayToDisk=$backupToDisk\ndisk=${backupToDisk[0]}:\nmytime=${time.hour}:${time.minute}\nscript=C:\\Users\\smartassraty\\FlutterProject\\lib\\scripts\\Script#1.bat");
                                  Navigator.pop(context);
                                  String out = "blank";
                                  Process.run("C:\\Users\\smartassraty\\FlutterProject\\lib\\scripts\\schScript.bat", []).then((value) => out = value.stdout);
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: Text(out),
                                        );
                                      }
                                    );
                                  
                                }
                              }, 
                              child: const Text("Confirm")
                            ),
                          ],
                        ),
                      )
                    );
                  }
                );
              },
            ),
          ],
        )
      ),
    );
  }
selectTime(BuildContext context) async {
  TimeOfDay? timeOfDay = await showTimePicker(
    context: context, 
    initialTime: time,
    initialEntryMode: TimePickerEntryMode.dial
  );
  if(timeOfDay != null && timeOfDay != time){
    setState(() {
      time = timeOfDay;
    });
  }
}
}
