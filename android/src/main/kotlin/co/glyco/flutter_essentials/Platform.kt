package co.glyco.flutter_essentials

import android.app.Activity
import android.app.Application
import android.content.Context
import android.hardware.SensorManager
import android.os.Bundle
import java.lang.NullPointerException
import java.lang.ref.WeakReference
import android.os.Build



class Platform {
    companion object {
        val appContext: Context
            get() = getCurrentActivity().applicationContext

        private var lifecycleListener: ActivityLifecycleContextListener? = null

        fun getCurrentActivity(): Activity {
            var activity = lifecycleListener?.activity

            if (activity == null) {
                throw NullPointerException("The current Activity can not be detected. Ensure that you have called Init in your Activity or Application class.")
            }

            return activity
        }

        fun hasApiLevel(versionCode : Int): Boolean{
            return Build.VERSION.SDK_INT >= versionCode
        }

        // Android 24
        val hasApiLevelN : Boolean
            get() = hasApiLevel(Build.VERSION_CODES.N)

        // Android 25
        val hasApiLevelNMr1 : Boolean
            get() = hasApiLevel(Build.VERSION_CODES.N_MR1)

        // Android 26
        val hasApiLevelO : Boolean
            get() = hasApiLevel(Build.VERSION_CODES.O)

        // Android 27
        val hasApiLevelOMr1 : Boolean
            get() = hasApiLevel(Build.VERSION_CODES.O_MR1)

        // Android 28
        val hasApiLevelP : Boolean
            get() = hasApiLevel(Build.VERSION_CODES.P)

        val sensorManager : SensorManager?
            get() = appContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    }

    constructor(application: Application) {
        lifecycleListener = ActivityLifecycleContextListener()
        application.registerActivityLifecycleCallbacks(lifecycleListener)
    }

    constructor(activity: Activity) : this(activity.application) {
        lifecycleListener?.activity = activity
    }
}

class ActivityLifecycleContextListener : Application.ActivityLifecycleCallbacks {
    private var currentActivity: WeakReference<Activity?>? = null

    var activity: Activity?
        get() = currentActivity?.get()
        set(value) {
            currentActivity = WeakReference(value)
        }

    override fun onActivityPaused(p0: Activity?) {
        p0?.let { activity = it }
    }

    override fun onActivityResumed(p0: Activity?) {
        p0?.let { activity = it }
    }

    override fun onActivityStarted(p0: Activity?) {
    }

    override fun onActivityDestroyed(p0: Activity?) {
    }

    override fun onActivitySaveInstanceState(p0: Activity?, p1: Bundle?) {
    }

    override fun onActivityStopped(p0: Activity?) {
    }

    override fun onActivityCreated(p0: Activity?, p1: Bundle?) {
        p0?.let { activity = it }
    }

}