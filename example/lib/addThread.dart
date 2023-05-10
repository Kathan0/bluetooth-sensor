import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class addThread extends StatefulWidget {
  final Function function;
  const addThread({required this.function});

  @override
  State<addThread> createState() => _addThreadState();
}

class _addThreadState extends State<addThread> {
  void submitThread() {
    widget.function();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextButton(
            onPressed: submitThread, 
            child: Text("Add Thread"))
        ],
      ),
    );
  }
}
