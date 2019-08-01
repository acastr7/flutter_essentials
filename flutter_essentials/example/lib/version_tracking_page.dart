import 'package:flutter/material.dart';
import 'package:flutter_essentials/version_tracking.dart';

class VersionTrackingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VersionTrackingPage();
}

class _VersionTrackingPage extends State<VersionTrackingPage> {
  String _versionStatus = "Unknown";

  @override
  void initState() {
    super.initState();
    _versionStatus = VersionTracking.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version Tracking'),
      ),
      body: Center(
        child: Text(_versionStatus),
      ),
    );
  }
}
