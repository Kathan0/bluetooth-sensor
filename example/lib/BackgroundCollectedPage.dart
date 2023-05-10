import 'package:flutter/material.dart';

import './models/threads.dart';
import './helpers/LineChart.dart';
import './helpers/PaintStyle.dart';

class BackgroundCollectedPage extends StatelessWidget {
  late final DataSample sample;

  BackgroundCollectedPage({required this.sample});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collected data'),
        actions: <Widget>[],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(children: [
            Text("Magnetometer Data",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
            sample.samples["magnetometer"]!.length != 0
                ? Table(
                    children: [
                      TableRow(children: [
                        Text("X"),
                        Text("Y"),
                        Text("Z"),
                      ]),
                      ...sample.samples["magnetometer"]!.map((e) {
                        int index = e.indexOf(',');
                        String x = (e.substring(0, index));
                        e = e.substring(index + 1);
                        index = e.indexOf(',');
                        String y = (e.substring(0, index));
                        e = e.substring(index + 1);
                        String z = e;
                        int check = z.indexOf('<');
                        if (check != -1) {
                          z = z.substring(0, check);
                        }

                        return TableRow(children: [
                          Text(x),
                          Text(y),
                          Text(z),
                        ]);
                      })
                    ],
                  )
                : Text("No data sent",
                    style:
                        TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
            Divider(
              height: 10,
            ),
            Text("Orientation Data", style: TextStyle(fontSize: 30)),
            sample.samples["orientation"]!.length != 0
                ? Table(
                    children: [
                      TableRow(children: [
                        Text("Yaw"),
                        Text("Pitch"),
                        Text("Roll"),
                      ]),
                      ...sample.samples["orientation"]!.map((e) {
                        int index = e.indexOf(',');
                        String x = (e.substring(0, index));
                        e = e.substring(index + 1);
                        index = e.indexOf(',');
                        String y = (e.substring(0, index));
                        e = e.substring(index + 1);
                        String z = (e);
                        int check = z.indexOf('<');
                        if (check != -1) {
                          z = z.substring(0, check);
                        }

                        return TableRow(children: [
                          Text(x),
                          Text(y),
                          Text(z),
                        ]);
                      })
                    ],
                  )
                : Text("No data sent", style: TextStyle(fontSize: 15)),
            Divider(
              height: 10,
            ),
            Text("Gyroscope Data",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
            sample.samples["gyro"]!.length != 0
                ? Table(
                    children: [
                      TableRow(children: [
                        Text("X"),
                        Text("Y"),
                        Text("Z"),
                      ]),
                      ...sample.samples["gyro"]!.map((e) {
                        int index = e.indexOf(',');
                        String x = (e.substring(0, index));
                        e = e.substring(index + 1);
                        index = e.indexOf(',');
                        String y = (e.substring(0, index));
                        e = e.substring(index + 1);
                        String z = (e);
                        int check = z.indexOf('<');
                        if (check != -1) {
                          z = z.substring(0, check);
                        }

                        return TableRow(children: [
                          Text(x),
                          Text(y),
                          Text(z),
                        ]);
                      })
                    ],
                  )
                : Text("No data sent", style: TextStyle(fontSize: 15)),
          ]);
        },
        itemCount: 1,
      ),
    );
  }
}
