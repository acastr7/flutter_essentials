import 'package:flutter/material.dart';
import 'package:flutter_essentials_example/app_info_page.dart';
import 'package:flutter_essentials_example/preferences_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home',
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("App Info"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new AppInfoPage()),
                );
              },
            ),
            RaisedButton(
              child: Text("Preferences"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new PreferencesPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
