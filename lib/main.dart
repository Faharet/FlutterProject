import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:ffi/ffi.dart' as pffi;
import 'controller.dart' as control;
import 'calendar.dart' as calendar;

late control.Drive drive;
bool route = false;

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
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  control.Controller controller = control.Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState((){
                controller.drives.clear();
                route = false;
              });
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text("ByEvent"),
                  );
                }
              );
            },
            child: const Text('ByEvent'),
          ),
          ElevatedButton(onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (BuildContext context) => const calendar.CalendarPage()));
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return const AlertDialog(
                  content: Text("ByTable"),);
              });
          },
          child: const Text("ByTable"),)
        ],
      ),
      body: Center(
        child: route ? driveController(drive) : viewController(),
      ),
    );
  }

  Widget viewController(){
    controller.getButtons();
    return TimerBuilder.periodic(
      const Duration(seconds: 1), 
      builder: (context) {
        return Center(
          child: Column(
            children: <Widget>[
              GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.drives.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100.0,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0
                ),
                itemBuilder: (context, i){
                  return Center(
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          drive = controller.drives[i];
                          route = true;
                        });
                      }, 
                      child: Text(controller.drives[i].letter.toDartString() + controller.drives[i].label.toDartString()),
                    )
                  );
                }
              ),
            ]
          )
        ); 
      },
    );
  }

  Widget driveController(control.Drive button){
    return TimerBuilder.periodic(
      const Duration(seconds: 1), 
      builder: (context) {
        controller.getProcessLog(button);
        return Center(
          child: Text(controller.processLog)
        ); 
      },
    );
  }
}
