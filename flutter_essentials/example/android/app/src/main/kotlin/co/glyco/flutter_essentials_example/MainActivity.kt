package co.glyco.flutter_essentials_example

import android.os.Bundle
import co.glyco.flutter_essentials.Platform

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    Platform(this)
    GeneratedPluginRegistrant.registerWith(this)

  }
}
