import 'package:flutter/material.dart';
import 'package:flutter_essentials/phone_dialer.dart';
import 'package:flutter/services.dart';

class PhoneDialerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneDialerPage();
}

class _PhoneDialerPage extends State<PhoneDialerPage>{
  var _phoneNumberController = TextEditingController();
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
      isSupported = await PhoneDialer.isSupported();
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
            new TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            RaisedButton(
              child: Text("Call Phone"),
              onPressed: () async {
                await PhoneDialer.open(_phoneNumberController.text);
              },
            ),
            Text('Error: $_errorMsg'),
          ],
        ),
      ),
    );
  }

}