// import 'dart:convert';
// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:scoped_model/scoped_model.dart';

// class DataSample {
//   // double temperature1;
//   // double temperature2;
//   // double waterpHlevel;
//   // DateTime timestamp;
//   Map<String, List<String>> samples;

//   DataSample(
//       {
//       // required this.temperature1,
//       // required this.temperature2,
//       // required this.waterpHlevel,
//       // required this.timestamp,
//       required this.samples});
// }

// class BackgroundCollectingTask extends Model {
//   static BackgroundCollectingTask of(
//     BuildContext context, {
//     bool rebuildOnChange = false,
//   }) =>
//       ScopedModel.of<BackgroundCollectingTask>(
//         context,
//         rebuildOnChange: rebuildOnChange,
//       );

//   final BluetoothConnection _connection;
//   List<int> _buffer = List<int>.empty(growable: true);

//   // @TODO , Such sample collection in real code should be delegated
//   // (via `Stream<DataSample>` preferably) and then saved for later
//   // displaying on chart (or even stright prepare for displaying).
//   // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
//   // List<DataSample> samples = List<DataSample>.empty(growable: true);

//   bool inProgress = false;

//   BackgroundCollectingTask._fromConnection(
//       this._connection, DataSample samples) {
//     _connection.input!.listen((data) {
//       String s = "";
//       for (int i = 0; i < data.length; i++) s += String.fromCharCode(data[i]);
//       int x = s.indexOf(',');
//       int code = int.parse(s.substring(1, x));
//       // print("======================");
//       // print(s);
//       // print(code);

//       switch (code) {
//         case 2: //magnetometer
//           {
//             // print(samples.samples["magnetometer"]);
//             s = s.substring(x + 1);
//             x = s.indexOf(',');
//             s = s.substring(x + 1);
//             // print(s);
//             int check = s.indexOf('<');
//             if (check != -1) {
//               print(check);
//               print("=============================");
//               s = s.substring(0, check);
//             }
//             samples.samples["magnetometer"]!.add(s);
//             break;
//           }
//         case 3: //orientation
//           {
//             // print(s);
//             s = s.substring(x + 1);
//             x = s.indexOf(',');
//             s = s.substring(x + 1);
//             int check = s.indexOf('<');
//             if (check != -1) {
//               s = s.substring(0, check);
//             }
//             samples.samples["orientation"]!.add(s);
//             break;
//           }
//         case 4: //gyro
//           {
//             // print("=============gyro================");
//             // print(samples.samples["magnetometer"]);
//             // print("===========================");
//             // print(s);
//             s = s.substring(x + 1);
//             x = s.indexOf(',');
//             s = s.substring(x + 1);
//             int check = s.indexOf('<');
//             if (check != -1) {
//               s = s.substring(0, check);
//             }
//             samples.samples["gyro"]!.add(s);
//             break;
//           }
//       }

//       // while (true) {
//       //   // If there is a sample, and it is full sent
//       //   int index = _buffer.indexOf('t'.codeUnitAt(0));
//       //   if (index >= 0 && _buffer.length - index >= 7) {
//       //     // final DataSample sample = DataSample(
//       //     //     temperature1: (_buffer[index + 1] + _buffer[index + 2] / 100),
//       //     //     temperature2: (_buffer[index + 3] + _buffer[index + 4] / 100),
//       //     //     waterpHlevel: (_buffer[index + 5] + _buffer[index + 6] / 100),
//       //     //     timestamp: DateTime.now());
//       //     // _buffer.removeRange(0, index + 7);

//       //     // samples.add(sample);
//       //     // notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
//       //     // //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
//       //   }
//       //   // Otherwise break
//       //   else {
//       //     break;
//       //   }
//       // }
//     }).onDone(() {
//       inProgress = false;
//       notifyListeners();
//     });
//   }

//   static Future<BackgroundCollectingTask> connect(
//       BluetoothDevice server, DataSample sample) async {
//     final BluetoothConnection connection =
//         await BluetoothConnection.toAddress(server.address);
//     return BackgroundCollectingTask._fromConnection(connection, sample);
//   }

//   void dispose() {
//     _connection.dispose();
//   }

//   Future<void> start(DataSample samples) async {
//     inProgress = true;
//     _buffer.clear();
//     samples.samples["temperature"]!.clear();
//     samples.samples["magnetometer"]!.clear();
//     samples.samples["orientation"]!.clear();
//     notifyListeners();
//     _connection.output.add(ascii.encode('start'));
//     await _connection.output.allSent;
//   }

//   Future<void> cancel() async {
//     inProgress = false;
//     notifyListeners();
//     _connection.output.add(ascii.encode('stop'));
//     await _connection.finish();
//   }

//   Future<void> pause() async {
//     inProgress = false;
//     notifyListeners();
//     _connection.output.add(ascii.encode('stop'));
//     await _connection.output.allSent;
//   }

//   Future<void> reasume() async {
//     inProgress = true;
//     notifyListeners();
//     _connection.output.add(ascii.encode('start'));
//     await _connection.output.allSent;
//   }

//   // Iterable<DataSample> getLastOf(Duration duration, String name) {
//   //   DateTime startingTime = DateTime.now().subtract(duration);
//   //   int i = samples.samples[name]!.length;
//   //   do {
//   //     i -= 1;
//   //     if (i <= 0) {
//   //       break;
//   //     }
//   //   } while (samples[i].timestamp.isAfter(startingTime));
//   //   return samples.getRange(i, samples.samples[name]!.length);
//   // }
// }
