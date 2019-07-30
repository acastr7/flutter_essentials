package co.glyco.flutter_essentials

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import java.lang.NullPointerException
import java.lang.ref.WeakReference

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