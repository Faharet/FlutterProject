import 'package:flutter/material.dart';
import 'view_controller.dart' as pm;
import 'package:timer_builder/timer_builder.dart';

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
              pm.ViewController viewController = pm.ViewController();
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
                              viewController.setButtonName(viewController.elements[i]);
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text("Selected ${viewController.elements[i]}"),
                                    );
                                  }
                                );
                            }, 
                            child: Text(viewController.elements[i]),
                          )
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0), 
                      child: Text(
                        viewController.processLog, style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),
                      ),
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
