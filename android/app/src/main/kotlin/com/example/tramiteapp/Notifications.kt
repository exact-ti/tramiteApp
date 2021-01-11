package com.example.tramiteapp

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat

object Notifications {
    const val NOTIFICATION_ID_BACKGROUND_SERVICE = 1000000000.toInt()

    private const val CHANNEL_ID_BACKGROUND_SERVICE = "background_service"
    
    fun createNotificationChannels(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID_BACKGROUND_SERVICE,
                "Background Service",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    fun buildForegroundNotification(context: Context): Notification {
        return NotificationCompat
            .Builder(context, CHANNEL_ID_BACKGROUND_SERVICE)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setAutoCancel(true)
            .setContentTitle("Background Service")
            .setContentText("Keeps app process on foreground.")
            .build()
    }

    fun onCancel(context: Context) {
        val notificationManager = context.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(NOTIFICATION_ID_BACKGROUND_SERVICE)
    }
}