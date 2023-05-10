import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

import './models/threads.dart';
import './threadList.dart';
import './addThread.dart';

import './BackgroundCollectedPage.dart';
import './BackgroundCollectingTask.dart';
import './ChatPage.dart';
import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';

class Thread extends StatefulWidget {
  BuildContext context;
  Thread({required this.context});

  @override
  State<Thread> createState() => _ThreadState(context: this.context);
}

class _ThreadState extends State<Thread> {
  BuildContext context;
  _ThreadState({required this.context});

  final List<Threads> _userThreads = [];

  void add_thread_to_list(BluetoothDevice device, BluetoothConnection connection) {
    setState(() {
      _userThreads.add(Threads(device: device, connection: connection));
    });
    showDialog(
      context: context, 
      builder: (BuildContext context){
      return AlertDialog(
        title: Text("User Added"),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.of(context).pop())
        ],
      );
    });
  }

  // void startAddNewThread(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (_) {
  //         return GestureDetector(
  //           onTap: () {},
  //           child: addThread(function: add_thread_to_list),
  //           behavior: HitTestBehavior.opaque,
  //         );
  //       });
  // }

  // void deleteThread(BluetoothDevice id) {
  //   setState(() {
  //     _userThreads.removeWhere((element) => element.device == id);
  //   });
  // }

  void go_back() {
    Navigator.pop(this.context);
  }

  BluetoothState _bluetoothState = BluetoothState.STATE_BLE_ON;
  List<Threads> users = [];

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  // BackgroundCollectingTask? _collectingTask;
  Threads? user;

  bool _autoAcceptPairingRequests = false;
  DataSample samples = new DataSample(samples: {
    "temperature": [],
    "magnetometer": [],
    "orientation": [],
    "gyro": []
  });

  Widget printData() {
    return Column(
      children: [
        Text("Magnetometer"),
        Text("X, Y, Z"),
        ...samples.samples["magnetometer"]!.map((e) => Text(e
            // e[0].toString() + " " + e[1].toString() + " " + e[2].toString()
            )),
        Divider(height: 20),
        Text("Orientation"),
        Text("Yaw, Pitch, Roll"),
        ...samples.samples["orientation"]!.map((e) => Text(e
            // e[0].toString() + " " + e[1].toString() + " " + e[2].toString()
            )),
        Divider(height: 20),
        Text("Gyro"),
        Text("X, Y, Z"),
        ...samples.samples["gyro"]!.map((e) => Text(e
            // e[0].toString() + " " + e[1].toString() + " " + e[2].toString()
            ))
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    user?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }
  void function() async {
        if (user?.inProgress ?? false) {
      await user!.cancel();
      setState(() {
        /* Update for `_collectingTask.inProgress` */
      });
    } else {
      final BluetoothDevice? selectedDevice =
          await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SelectBondedDevicePage(
                checkAvailability: false);
          },
        ),
      );

      if (selectedDevice != null) {
        // users.add(selectedDevice);
        await _startBackgroundTask(context, selectedDevice);
        setState(() {
          // print(samples);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Flutter App'),
      actions: [
        IconButton(
            onPressed: function,
                // () => startAddNewThread(context)
            //     () async {
            //   final BluetoothDevice? selectedDevice =
            //       await Navigator.of(this.context).push(
            //     MaterialPageRoute(
            //       builder: (context) {
            //         return DiscoveryPage();
            //       },
            //     ),
            //   );

            //   if (selectedDevice != null) {
            //     print('Discovery -> selected ' + selectedDevice.address);
            //   } else {
            //     print('Discovery -> no device selected');
            //   }
            // },
            icon: Icon(Icons.add))
      ],
      leading: BackButton(onPressed: go_back),
    );

    return Scaffold(
        appBar: appBar,
        body: Column(children: [
          Container(
            child: Flexible(
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    title: const Text('Bluetooth status'),
                    subtitle: Text(_bluetoothState.toString()),
                    trailing: ElevatedButton(
                      child: const Text('Settings'),
                      onPressed: () {
                        FlutterBluetoothSerial.instance.openSettings();
                      },
                    ),
                  ),
                  Divider(),
                  // ThreadList(
                  //     userThreads: _userThreads,
                  //     function: (){},
                  //     contextMain: context),
                  Divider(),
                  ListTile(
                    title: ElevatedButton(
                      child: ((user?.inProgress ?? false)
                          ? const Text(
                              'Disconnect and stop background collecting')
                          : const Text(
                              'Connect to start background collecting')),
                      onPressed: function
                      // () async {
                      //   if (user?.inProgress ?? false) {
                      //     await user!.cancel();
                      //     setState(() {
                      //       /* Update for `_collectingTask.inProgress` */
                      //     });
                      //   } else {
                      //     final BluetoothDevice? selectedDevice =
                      //         await Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) {
                      //           return SelectBondedDevicePage(
                      //               checkAvailability: false);
                      //         },
                      //       ),
                      //     );

                      //     if (selectedDevice != null) {
                      //       // users.add(selectedDevice);
                      //       await _startBackgroundTask(context, selectedDevice);
                      //       setState(() {
                      //         // print(samples);
                      //       });
                      //     }
                      //   }
                      // },
                    ),
                  ),
                  ListTile(
                    title: ElevatedButton(
                        child: const Text('View background collected data'),
                        onPressed: () => {
                              Navigator.of(this.context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BackgroundCollectedPage(
                                        sample: samples);
                                  },
                                ),
                              )
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       _buildPopupDialog(context),
                              // )
                            }),
                  ),
                ],
              ),
            ),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: function
                //() => startAddNewThread(context),
        ));
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      user = await Threads.connect(server, samples);
      await user!.start(samples);
      setState(() {
        add_thread_to_list(server, user!.connection);
      });
    } catch (ex) {
      user?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            // content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
