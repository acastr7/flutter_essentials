import 'package:flutter/material.dart';
import 'package:flutter_essentials/accelerometer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_essentials/types.dart';

class AccelerometerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccelerometerPage();
}

class _AccelerometerPage extends State<AccelerometerPage> {
  var _isSupported = false;
  var _errorMsg = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool isSupported = false;
    String errorMsg = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isSupported = await Accelerometer.isSupported;
    } on PlatformException {
      errorMsg = 'Failed to isSupported';
    }

    if (!mounted) return;

    setState(() {
      _isSupported = isSupported;
      _errorMsg = errorMsg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('IsSupported: $_isSupported'),
            RaisedButton(
              child: Text("Start Tracking"),
              onPressed: () async {
                await Accelerometer.start(SensorSpeed.UI);
              },
            ),
            RaisedButton(
              child: Text("Stop Tracking"),
              onPressed: () async {
                await Accelerometer.stop();

                setState(() {});
              },
            ),
            StreamBuilder<AccelerometerData>(
              stream: Accelerometer.accelerometerDataController.stream
                  .asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<AccelerometerData> snapshot) {
                if (snapshot.hasError) {
                  return Text('Values: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Text('X: ${snapshot.data.acceleration.x}'),
                      Text('Y: ${snapshot.data.acceleration.y}'),
                      Text('Z: ${snapshot.data.acceleration.z}')
                    ],
                  );
                }

                return Text('Values: No Values Collected');
              },
            ),
            StreamBuilder<bool>(
              stream: Accelerometer.shakeDetectedController.stream
                  .asBroadcastStream(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasError) {
                  return Text('Values: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  return Container(
                    height: 50,
                    color: snapshot.data ? Colors.green : Colors.red,
                    child: Text('IsShaking: ${snapshot.data}'),
                  );
                }

                return Text('IsShaking: false');
              },
            ),
            Text('Error: $_errorMsg'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Accelerometer.stop();
    super.dispose();
  }
}
