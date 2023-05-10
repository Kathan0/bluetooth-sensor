import 'package:flutter/material.dart';
import './models/threads.dart';
import 'dart:isolate';
import 'dart:async';

class ThreadList extends StatelessWidget {
  final List<Threads> userThreads;
  final Function function;
  BuildContext contextMain;
  ThreadList({required this.function, required this.userThreads, required this.contextMain});

  Widget _buildPopupDialog(BuildContext context, String text) {
    return new AlertDialog(
      title: const Text('Message from Thread'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget thread_return(String? title, String id) {
    return Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: ListTile(
          subtitle: FittedBox(
                child: Text('ID: $id'),
              ),
          title: Text(
            title!,
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // subtitle: ElevatedButton(
          //     onPressed: () => thread_call(id), child: Text("Send to Thread")),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => function(id),
          ),
        ));
  }

  Widget build(BuildContext context) {
    return Container(
        child: userThreads.isEmpty
            ? const Text(
                'No Threads added yet!',
                style: TextStyle(fontSize: 25),
              )
            : SizedBox(
              child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return thread_return(
                        userThreads[index].device.name, userThreads[index].device.address);
                  },
                  itemCount: userThreads.length,
                ),
            )
              );
  }
}
