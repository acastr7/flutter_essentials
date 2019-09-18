import 'package:flutter/material.dart';
import 'package:flutter_essentials/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeviceInfopage();
}

class _DeviceInfopage extends State<DeviceInfoPage> {
  String _model;
  String _manufacturer;
  String _name;
  String _version;
  String _deviceType;
  String _devicePlatform;
  String _idiom;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String model;
    String manufacturer;
    String name;
    String version;
    String deviceType;
    String devicePlatform;
    String idiom;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      model = await DeviceInfo.model;
    } on PlatformException {
      model = 'Failed to get model.';
    }

    try {
      manufacturer = await DeviceInfo.manufacturer;
    } on PlatformException {
      manufacturer = 'Failed to get manufacturer.';
    }

    try {
      name = await DeviceInfo.name;
    } on PlatformException {
      name = 'Failed to get name.';
    }

    try {
      version = await DeviceInfo.version;
    } on PlatformException {
      version = 'Failed to get version.';
    }

    try {
      deviceType = (await DeviceInfo.deviceType).toString();
    } on PlatformException {
      deviceType = 'Failed to get deviceType.';
    }

    try {
      devicePlatform = (await DeviceInfo.devicePlatform).toString();
    } on PlatformException {
      devicePlatform = 'Failed to get devicePlatform.';
    }

    try {
      idiom = (await DeviceInfo.idiom).toString();
    } on PlatformException {
      idiom = 'Failed to get deviceType.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _model = model;
      _manufacturer = manufacturer;
      _name = name;
      _version = version;
      _deviceType = deviceType;
      _devicePlatform = devicePlatform;
      _idiom = idiom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Model: $_model'),
            Text('Version: $_manufacturer'),
            Text('Name: $_name'),
            Text('Version: $_version'),
            Text('Device Type: $_deviceType'),
            Text('Device Platform: $_devicePlatform'),
            Text('Idiom: $_idiom'),
          ],
        ),
      ),
    );
  }
}
