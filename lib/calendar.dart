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
  TextEditingController controller = TextEditingController();
  late String diskToBackup = "not set";
  late String backupToDisk = "not set";
  late TimeOfDay time = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar(
              focusedDay: DateTime.now(), 
              firstDay: DateTime.now(), 
              lastDay: DateTime.utc(2023),
              onDaySelected: (selectedDay, focusedDay){
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    content: Card(
                      color: Colors.amber,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.drive_eta),
                              labelText: "disk to be backed up",
                              hintText: "[diskLetter]:",
                            ),
                            validator: (value){
                              RegExp reg = RegExp("^[A-Z]:");
                              if(value!.isEmpty){
                                return "Can not be empty";
                              }
                              if(!value.contains(reg)){
                                return "Usage: {[letter]:}"; 
                              }
                            },
                            onChanged: (String value){
                                if(formkey.currentState != null){
                                  formkey.currentState!.validate();
                                  setState(() {
                                  backupToDisk = value;
                                  });
                                }
                            }
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.drive_eta),
                              labelText: "disk to save the backup",
                              hintText: "[diskLetter]:",
                            ),
                            validator: (value){
                              RegExp reg = RegExp("^[A-Z]:");
                              if(value!.isEmpty){
                                return "Can not be empty";
                              }
                              if(!value.contains(reg)){
                                return "Usage: {[letter]:}"; 
                              }
                            },
                            onChanged: (String value){
                                setState(() {
                                  backupToDisk = value;
                                });
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            child: ElevatedButton(
                            onPressed: (){
                              selectTime(context);
                            }, 
                            child: const Text("Set time"))
                          ),
                        ],
                      ),
                    ),
                  );
                }).then((value) async {
                  var file = await File("lib\\scripts\\config.ini").writeAsString("way=$diskToBackup\ndisk=$backupToDisk\nmytime=${time.hour}:${time.minute}\nscript=C:\\Script\\Script#1.txt");
                } );
              },),
              Text("$diskToBackup $backupToDisk ${time.hour}:${time.minute}"),
              ElevatedButton(
                onPressed: (){

                }, 
                child: const Text("Ready"))
          ],
        ),
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
