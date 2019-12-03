package co.glyco.flutter_essentials

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel


class FlutterEssentialsPlugin(val activity: Activity) : MethodCallHandler {

    companion object {

        private val appInfo = AppInfo()
        private val appPreferences = AppPreferences()
        private val deviceInfo = DeviceInfo()
        private val phoneDialer = PhoneDialer()
        private var accelerometer: Accelerometer? = null;

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_essentials")
            Platform(registrar.activity())
            channel.setMethodCallHandler(FlutterEssentialsPlugin(registrar.activity()))
            accelerometer = Accelerometer(registrar.messenger())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method.startsWith(AppInfo.prefix) -> appInfo.onMethodCall(call, result)
            call.method.startsWith(AppPreferences.prefix) -> appPreferences.onMethodCall(call, result)
            call.method.startsWith(DeviceInfo.prefix) -> deviceInfo.onMethodCall(call, result)
            call.method.startsWith(PhoneDialer.prefix) -> phoneDialer.onMethodCall(call, result)
            call.method.startsWith(Accelerometer.prefix) -> accelerometer?.onMethodCall(call, result)
            else -> result.notImplemented()
        }
    }
}
