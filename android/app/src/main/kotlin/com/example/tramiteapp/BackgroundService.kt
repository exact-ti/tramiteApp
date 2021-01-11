package com.example.tramiteapp

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain

class BackgroundService : Service(), LifecycleDetector.Listener {

    private var flutterEngine: FlutterEngine? = null

    override fun onCreate() {
        super.onCreate()

        val notification = Notifications.buildForegroundNotification(this)
        startForeground(Notifications.NOTIFICATION_ID_BACKGROUND_SERVICE, notification)

        LifecycleDetector.listener = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.getLongExtra(KEY_CALLBACK_RAW_HANDLE, -1)?.let { callbackRawHandle ->
            if (callbackRawHandle != -1L) setCallbackRawHandle(callbackRawHandle)
        }

        if (!LifecycleDetector.isActivityRunning) {
            startFlutterNativeView()
        }

        if (intent != null) {
            val ss:String = intent.getStringExtra("key_stop_service")
            if(ss=="true"){
                stopForegroundService()
            }
        }
    
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        LifecycleDetector.listener = null
    }

    override fun onBind(intent: Intent): IBinder? = null

    override fun onFlutterActivityCreated() {
        stopFlutterNativeView()
    }

    override fun onFlutterActivityDestroyed() {
        startFlutterNativeView()
    }

    private fun startFlutterNativeView() {
        if (flutterEngine != null) return

        Log.i("BackgroundService", "Starting FlutterEngine")

        getCallbackRawHandle()?.let { callbackRawHandle ->
            flutterEngine = FlutterEngine(this).also { engine ->
                val callbackInformation =
                    FlutterCallbackInformation.lookupCallbackInformation(callbackRawHandle)

                engine.dartExecutor.executeDartCallback(
                    DartExecutor.DartCallback(
                        assets,
                        FlutterMain.findAppBundlePath(),
                        callbackInformation
                    )
                )
            }
        }
    }

    private fun stopFlutterNativeView() {
        Log.i("BackgroundService", "Stopping FlutterEngine")
        flutterEngine?.destroy()
        flutterEngine = null
    }

    private fun getCallbackRawHandle(): Long? {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        val callbackRawHandle = prefs.getLong(KEY_CALLBACK_RAW_HANDLE, -1)
        return if (callbackRawHandle != -1L) callbackRawHandle else null
    }

    private fun setCallbackRawHandle(handle: Long) {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        prefs.edit().putLong(KEY_CALLBACK_RAW_HANDLE, handle).apply()
    }
    
    private fun stopForegroundService() {
        try {
            stopForeground(true)
            Notifications.onCancel(this)
        } catch (e: Exception) {
        Log.i("BackgroundService", "Surgió un error")
        }
        stopSelf()
    }

    companion object {
        private const val SHARED_PREFERENCES_NAME = "com.example.BackgroundService"

        private const val KEY_CALLBACK_RAW_HANDLE = "callbackRawHandle"

        private const val KEY_STOP_SERVICE = "key_stop_service"


        fun startService(context: Context, callbackRawHandle: Long) {
            val intent = Intent(context, BackgroundService::class.java).apply {
                putExtra(KEY_CALLBACK_RAW_HANDLE, callbackRawHandle)
                putExtra(KEY_STOP_SERVICE, "false")
            }
            ContextCompat.startForegroundService(context, intent)
        }

        fun stopService(context: Context, callbackRawHandle: Long) {
            val intent = Intent(context, BackgroundService::class.java).apply {
                putExtra(KEY_STOP_SERVICE, "true")
            }
            ContextCompat.startForegroundService(context, intent)
        }
    }

}
