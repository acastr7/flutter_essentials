package co.glyco.flutter_essentials

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.telephony.PhoneNumberUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.URLEncoder

class PhoneDialer : MethodChannel.MethodCallHandler {

    companion object {
        const val prefix: String = "PhoneDialer."
        const val intentCheck: String = "00000000000"
        const val knownArgumentKey: String = "number"

        fun resolveDialIntent(number: String): Intent? {
            var telUri = Uri.parse("tel:$number")
            return Intent(Intent.ACTION_DIAL, telUri)
        }

    }

    private val isSupported: Boolean
        get() {
            var pm = Platform.appContext.applicationContext.packageManager
            var dialIntent = resolveDialIntent(intentCheck)
            return dialIntent?.resolveActivity(pm) != null
        }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        var method = call.method.substringAfter(prefix)

        if (method == "isSupported") {
            result.success(isSupported)
        } else if (method == "open") {
            call.argument<String>(knownArgumentKey)?.let {
                dialNumber(it)
                result.success(null)
            } ?: result.error(method, "$knownArgumentKey not found", null)
        } else {
            result.notImplemented()
        }
    }

    fun dialNumber(number: String) {
        var phoneNumber: String
        if (Platform.hasApiLevelN) {
            phoneNumber = PhoneNumberUtils.formatNumber(number, java.util.Locale.getDefault(java.util.Locale.Category.FORMAT).country)
        } else if (Platform.hasApiLevel(Build.VERSION_CODES.LOLLIPOP)) {
            phoneNumber = PhoneNumberUtils.formatNumber(number, java.util.Locale.getDefault().country)
        } else {
            phoneNumber = PhoneNumberUtils.formatNumber(number)
        }

        phoneNumber = URLEncoder.encode(phoneNumber, "UTF-8")

        var dialIntent = resolveDialIntent(phoneNumber)?.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)?.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        Platform.appContext.startActivity(dialIntent)
    }

}