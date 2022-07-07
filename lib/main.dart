import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'view_controller.dart' as vc;
import 'drive_controller.dart' as dc;

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
  static late String button;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text("qwerwe"),
                  );
                }
              );
            },
            child: const Text('BatEventByProcess'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TimerBuilder.periodic(
            const Duration(seconds: 1), 
            builder: (context){
              vc.ViewController viewController = vc.ViewController();
              return Center(
                child: Column(
                  children: <Widget>[
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: viewController.elements.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 55.0,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0
                      ),
                      itemBuilder: (context, i){
                        return Center(
                          child: ElevatedButton(
                            onPressed: (){
                              button = viewController.elements[i];
                              Navigator.push(
                                context, 
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => dc.DriveController(b: button),
                                ),
                              );
                            }, 
                            child: Text(viewController.elements[i]),
                          )
                        );
                      }
                    ),
                  ]
                )
              );
            },
          )
        ],
      ),
    );
  }
}
