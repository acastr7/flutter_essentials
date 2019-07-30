import 'package:flutter/material.dart';
import 'package:flutter_essentials/flutter_essentials.dart';
import 'package:flutter/services.dart';

class AppInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppInfoPage();
}

class _AppInfoPage extends State<AppInfoPage> {
  String _packageName = 'Unknown';
  String _name = 'Unknown';
  String _version = 'Unknown';
  String _build = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String packageName;
    String name;
    String version;
    String build;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      packageName = await FlutterEssentials.appInfo.packageName;
    } on PlatformException {
      packageName = 'Failed to get package name.';
    }

    try {
      name = await FlutterEssentials.appInfo.name;
    } on PlatformException {
      name = 'Failed to get app name.';
    }

    try {
      version = await FlutterEssentials.appInfo.versionString;
    } on PlatformException {
      version = 'Failed to get version.';
    }

    try {
      build = await FlutterEssentials.appInfo.buildString;
    } on PlatformException {
      build = 'Failed to get build.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _packageName = packageName;
      _name = name;
      _version = version;
      _build = build;
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
            Text('PackageName: $_packageName'),
            Text('App Name: $_name'),
            Text('Version: $_version'),
            Text('Build: $_build'),
            RaisedButton(
              child: Text("Show Settings UI"),
              onPressed: () async {
                await FlutterEssentials.appInfo.showSettingsUI;
              },
            )
          ],
        ),
      ),
    );
  }
}
