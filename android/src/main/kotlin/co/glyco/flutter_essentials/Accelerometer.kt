package co.glyco.flutter_essentials

import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.net.Uri
import android.os.Parcel
import android.os.Parcelable
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel


class Accelerometer(val messenger: BinaryMessenger) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    companion object {
        const val prefix: String = "Accelerometer."
        const val knownArgumentKeyStart: String = "startSpeed"


        fun resolveDialIntent(number: String): Intent? {
            var telUri = Uri.parse("tel:$number")
            return Intent(Intent.ACTION_DIAL, telUri)
        }

        private var listener: AccelerometerListener? = null
        private var accelerometer: Sensor? = null
        private var eventSink: EventChannel.EventSink? = null
    }

    init {
        var eventChannel = EventChannel(messenger, "flutter_essentials.Accelerometer")
        eventChannel.setStreamHandler(this)
    }

    private val isSupported: Boolean
        get() = Platform.sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) != null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        var method = call.method.substringAfter(prefix)

        if (method == "isSupported") {
            result.success(isSupported)
        } else if (method == "start") {
            call.argument<String>(knownArgumentKeyStart)?.let {
                var speed = SensorManager.SENSOR_DELAY_NORMAL
                when {
                    it.endsWith("UI") -> speed = SensorManager.SENSOR_DELAY_UI
                    it.endsWith("GAME") -> speed = SensorManager.SENSOR_DELAY_GAME
                    it.endsWith("FASTEST") -> speed = SensorManager.SENSOR_DELAY_FASTEST
                }
                start(speed)
                result.success(null)
            } ?: result.error(method, "$knownArgumentKeyStart not found", null)
        } else if (method == "stop") {
            stop()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, incomingEventSink: EventChannel.EventSink?) {
        eventSink = incomingEventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun start(sensorSpeed: Int) {
        listener = AccelerometerListener()
        accelerometer = Platform.sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        Platform.sensorManager?.registerListener(listener, accelerometer, sensorSpeed)
    }

    fun stop() {

        if (listener == null || accelerometer == null) return

        Platform.sensorManager?.unregisterListener(listener, accelerometer)
        listener = null
        accelerometer = null
    }

    inner class AccelerometerListener : SensorEventListener {
        // acceleration due to gravity
        val gravity = 9.81

        override fun onSensorChanged(event: SensorEvent?) {
            if (event != null) {
                val sensorValues = DoubleArray(event.values.size)
                for (i in 0 until event.values.size) {
                    sensorValues[i] = event.values[i].toDouble() / gravity
                }
                eventSink?.success(sensorValues)
            }
        }

        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        }


    }

}