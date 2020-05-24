import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> devices = <String>[];
  bool isScanning = false;
  FlutterScanBluetooth bluetoothScanner = FlutterScanBluetooth();

  @override
  void initState() {
    super.initState();

    bluetoothScanner.devices.listen((device) {
      setState(() {
        DateTime time = new DateTime.now();
        devices.add("${device.name}\n${device.address}\n$time");
      });
    });

    bluetoothScanner.scanStopped.listen((device) {
      setState(() {
        isScanning = false;
        Fluttertoast.showToast(msg: "Stopping discovery of devices");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: Text('Bluetooth App'),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: Text("${devices[index]}"),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                )),
                RaisedButton(
                    child:
                        Text(isScanning ? 'Stop Discovery' : 'Start Discovery'),
                    onPressed: () async {
                      try {
                        if (isScanning) {
                          await bluetoothScanner.stopScan();
                          setState(() {
                            devices.clear();
                            Fluttertoast.showToast(
                                msg: "Stopping discovery of devices");
                          });
                        } else {
                          await bluetoothScanner.startScan(
                              pairedDevices: false);
                          setState(() {
                            isScanning = true;
                            Fluttertoast.showToast(
                                msg: "Starting discovery of devices");
                          });
                        }
                      } on PlatformException catch (e) {
                        debugPrint(e.toString());
                      }
                    })
              ],
            )));
  }
}
