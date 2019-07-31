import 'package:flutter/material.dart';
import 'package:flutter_essentials/flutter_essentials.dart';
import 'package:flutter/services.dart';

class PreferencesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferencesPage();
}

class _PreferencesPage extends State<PreferencesPage> {
  var _intValue = TextEditingController();
  var _boolValue = TextEditingController();
  var _stringValue = TextEditingController();
  var _doubleValue = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    int intValue;
    bool boolValue;
    String stringValue;
    double doubleValue;
    String errorMessage;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      intValue =
          await FlutterEssentials.preferences.getInt("testIntKeyValue", 0);
    } on PlatformException {
      errorMessage = 'Failed to get int value.';
    }

    try {
      boolValue = await FlutterEssentials.preferences
          .getBool("testBoolKeyValue", false);
    } on PlatformException {
      errorMessage = 'Failed to get bool value.';
    }

    try {
      stringValue = await FlutterEssentials.preferences
          .getString("testStringKeyValue", null);
    } on PlatformException {
      errorMessage = 'Failed to get string value.';
    }

    try {
      doubleValue = await FlutterEssentials.preferences
          .getDouble("testDoubleKeyValue", 0);
    } on PlatformException {
      errorMessage = 'Failed to get double value.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _boolValue.text = boolValue.toString();
      _intValue.text = intValue.toString();
      _stringValue.text = stringValue;
      _doubleValue.text = doubleValue.toString();
      _errorMessage = errorMessage;
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
            new TextFormField(
              keyboardType: TextInputType.number,
              controller: _intValue,
              decoration: InputDecoration(labelText: 'Int Test'),
            ),
            new TextFormField(
              keyboardType: TextInputType.number,
              controller: _doubleValue,
              decoration: InputDecoration(labelText: 'Double Test'),
            ),
            new TextFormField(
                keyboardType: TextInputType.number,
                controller: _stringValue,
                decoration: InputDecoration(labelText: 'String Test')),
            Text('Bool Test: ${_boolValue.text}'),
            RaisedButton(
              child: Text("Update Values"),
              onPressed: () async {
                await FlutterEssentials.preferences
                    .setInt("testIntKeyValue", int.parse(_intValue.text));
                await FlutterEssentials.preferences.setDouble(
                    "testDoubleKeyValue", double.parse(_doubleValue.text));
              },
            ),
            RaisedButton(
                child: Text("Clear Values"),
                onPressed: () async {
                  await FlutterEssentials.preferences.clear();
                }),
          ],
        ),
      ),
    );
  }
}
