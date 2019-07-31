package co.glyco.flutter_essentials

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.app.Activity


class FlutterEssentialsPlugin(val activity: Activity) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_essentials")
            Platform(registrar.activity())
            channel.setMethodCallHandler(FlutterEssentialsPlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.startsWith(AppInfo.prefix)) {
            AppInfo().onMethodCall(call, result)
        }
        if (call.method.startsWith(AppPreferences.prefix)) {
            AppPreferences().onMethodCall(call, result)
        } else {
            result.notImplemented()
        }
    }
}
