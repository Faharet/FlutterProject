import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  final String title = "Calendar";

  @override
  State<CalendarPage> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
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
                    content: Text(selectedDay.day.toString() + selectedDay.weekday.toString()),
                  );
                });
              },),
          ],
        ),
      ),
    );
  }
}
