package co.glyco.flutter_essentials

import android.app.UiModeManager
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

class DeviceInfo : MethodChannel.MethodCallHandler {

    companion object {
        const val prefix: String = "DeviceInfo."
        const val Unknown: String = "Unknown"

        const val tabletCrossover: Int = 600

        private fun getSystemSetting(name: String): String {
            return Settings.System.getString(Platform.appContext.contentResolver, name)
        }

        private fun detectIdiom(uiMode: Int): String {
            if (uiMode == Configuration.UI_MODE_TYPE_NORMAL) {
                return Unknown
            }

            if (uiMode == Configuration.UI_MODE_TYPE_TELEVISION) {
                return "TV"
            }

            if (uiMode == Configuration.UI_MODE_TYPE_DESK) {
                return "Desktop"
            }

            return Unknown
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var method = call.method.substringAfter(prefix)

        when (method) {
            "model" -> {
                result.success(Build.MODEL)
            }
            "manufacturer" -> {
                result.success(Build.MANUFACTURER)
            }
            "name" -> {
                var name = getSystemSetting("device_name")
                if (name.isNullOrBlank()) {
                    name = Build.MODEL
                }
                result.success(name)
            }
            "version" -> {
                result.success(Build.VERSION.RELEASE)
            }
            "deviceType" -> {
                var isEmulator =
                        Build.FINGERPRINT.startsWith("generic") ||
                                Build.FINGERPRINT.startsWith("unknown") ||
                                Build.MODEL.contains("google_sdk") ||
                                Build.MODEL.contains("Emulator") ||
                                Build.MODEL.contains("Android SDK built for x86") ||
                                Build.MANUFACTURER.contains("Genymotion") ||
                                Build.MANUFACTURER.contains("VS Emulator") ||
                                (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
                                Build.PRODUCT == "google_sdk"
                if (isEmulator) {
                    result.success("Virtual")
                } else {
                    result.success("Physical")
                }

            }
            "devicePlatform" -> {
                result.success("Android")
            }
            "idiom" -> {

                var currentIdiom = Unknown

                // first try UIModeManager
                var uiModeManager = Platform.appContext.getSystemService(Context.UI_MODE_SERVICE) as UiModeManager

                try {
                    var uiMode: Int = uiModeManager?.currentModeType
                    if (uiMode == null) {
                        uiMode = Configuration.UI_MODE_TYPE_UNDEFINED
                    }
                    currentIdiom = detectIdiom(uiMode)
                } catch (ex: Exception) {
                    Log.d("deviceInfo", "Unable to detect using UiModeManager: ${ex.message}")
                }

                // then try Configuration
                if (currentIdiom == Unknown) {
                    var configuration = Platform.appContext.resources?.configuration
                    if (configuration != null) {
                        var uiMode = configuration.uiMode;
                        currentIdiom = detectIdiom((uiMode))

                        // now just guess
                        if (currentIdiom == Unknown) {
                            var minWidth = configuration.smallestScreenWidthDp;
                            var isWide = minWidth >= tabletCrossover;
                            currentIdiom = if (isWide) "Tablet" else "Phone"
                        }
                    }
                }

                // start clutching at straws
                if (currentIdiom == Unknown) {
                    var metrics = Platform.appContext.resources?.displayMetrics
                    if (metrics != null) {
                        var minSize = Math.min(metrics.widthPixels, metrics.heightPixels)
                        var isWide = minSize * metrics.density >= tabletCrossover
                        currentIdiom = if (isWide) "Tablet" else "Phone"
                    }
                }

                result.success(currentIdiom)
            }
            else -> result.notImplemented()
        }
    }

}