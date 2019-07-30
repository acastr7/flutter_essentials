package co.glyco.flutter_essentials

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager

class AppInfo : MethodChannel.MethodCallHandler {

    companion object {
        const val prefix : String = "AppInfo."
        val packageName: String
            get() {
                return Platform.appContext.applicationContext.packageName;
            }

    }

    private val packageInfo: PackageInfo
        get() {
            var pm = Platform.appContext.applicationContext.packageManager;
            var packageName = Platform.appContext.applicationContext.packageName;
            return pm.getPackageInfo(packageName, PackageManager.GET_META_DATA)
        }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var method = call.method.substringAfter(prefix)

        if (method == "packageName") {
            result.success(packageName)
        } else if (method == "name") {
            var applicationInfo = Platform.appContext.applicationContext.applicationInfo
            var pm = Platform.appContext.applicationContext.packageManager
            result.success(applicationInfo.loadLabel(pm))
        } else if (method == "versionString") {
            result.success(packageInfo.versionName)
        } else if (method == "buildString") {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                result.success(packageInfo.longVersionCode.toString())
            } else {
                @Suppress("DEPRECATION")
                result.success(packageInfo.versionCode.toString())
            }
        } else if (method == "showSettingsUI") {
            var settingsIntent = Intent()
            settingsIntent.action = android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS
            settingsIntent.addCategory(Intent.CATEGORY_DEFAULT)
            settingsIntent.data = android.net.Uri.parse("package:$packageName")
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)
            Platform.appContext.startActivity(settingsIntent)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

}