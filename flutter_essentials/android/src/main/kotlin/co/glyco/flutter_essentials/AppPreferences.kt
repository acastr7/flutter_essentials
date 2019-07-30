package co.glyco.flutter_essentials

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.preference.PreferenceManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

class AppPreferences : MethodChannel.MethodCallHandler {

    companion object {
        const val prefix : String = "Preferences."

        val lock = ReentrantLock()

        fun getPrivatePreferencesSharedName(feature: String): String {
            return "${AppInfo.packageName}.flutteressentials.$feature"
        }

        private fun platformContainsKey(key: String, sharedName: String?): Boolean {
            lock.withLock {
                var sharedPreferences = getSharedPreferences(sharedName)
                return sharedPreferences.contains(key)
            }
        }

        private fun platformRemove(key: String, sharedName: String?) {
            lock.withLock {
                var sharedPreferences = getSharedPreferences(sharedName)
                var editor = sharedPreferences.edit()
                editor.remove(key).apply()
            }
        }

        private fun platformClear(sharedName: String?) {
            lock.withLock {
                var sharedPreferences = getSharedPreferences(sharedName)
                var editor = sharedPreferences.edit()
                editor.clear().apply()
            }
        }

        private fun <T> platformSet(key: String, value: T, sharedName: String?) {
            lock.withLock {
                var sharedPreferences = getSharedPreferences(sharedName)
                var editor = sharedPreferences.edit()
                if (value == null) {
                    editor.remove(key)
                } else {
                    when (value) {
                        is String -> editor.putString(key, value)
                        is Int -> editor.putInt(key, value)
                        is Boolean -> editor.putBoolean(key, value)
                        is Long -> editor.putLong(key, value)
                        is Double -> {
                            var valueString = value.toString();
                            editor.putString(key, valueString);
                        }
                        is Float -> editor.putFloat(key, value)
                    }
                }
                editor.apply()
            }
        }

        private fun <T> platformGet(key: String, defaultValue: T?, sharedName: String?): T {
            lock.withLock {
                var sharedPreferences = getSharedPreferences(sharedName)
                if (defaultValue == null) {
                    return sharedPreferences.getString(key, null) as T
                } else {
                    when (defaultValue) {
                        is String -> return sharedPreferences.getString(key, defaultValue) as T
                        is Int -> return sharedPreferences.getInt(key, defaultValue) as T
                        is Boolean -> return sharedPreferences.getBoolean(key, defaultValue) as T
                        is Long -> return sharedPreferences.getLong(key, defaultValue) as T
                        is Double -> {
                            var savedDouble = sharedPreferences.getString(key, null);
                            if (savedDouble.isNullOrBlank()) {
                                return defaultValue
                            }

                            return savedDouble.toDouble() as T
                        }
                        is Float -> return sharedPreferences.getFloat(key, defaultValue) as T
                    }
                }
            }
        }

        private fun getSharedPreferences(sharedName: String?): SharedPreferences {
            var context = Platform.appContext

            return if (sharedName.isNullOrEmpty()) {
                PreferenceManager.getDefaultSharedPreferences(context)
            } else {
                context.getSharedPreferences(sharedName, Context.MODE_PRIVATE)
            }
        }


        fun ContainsKey(key: String, sharedName: String?): Boolean {
            return platformContainsKey(key, sharedName)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var method = call.method.substringAfter(prefix)

        if (method == "packageName") {

        } else if (method == "name") {
        } else if (method == "versionString") {
        } else if (method == "buildString") {

        } else if (method == "showSettingsUI") {

        } else {
            result.notImplemented()
        }
    }
}