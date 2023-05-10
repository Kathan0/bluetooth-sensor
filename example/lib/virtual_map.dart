import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class virtual_map extends StatelessWidget {
  const virtual_map();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(context: context),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Choose"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Here we are"),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Go Back"))
          ],
        )
      ],
    ));
  }
}
