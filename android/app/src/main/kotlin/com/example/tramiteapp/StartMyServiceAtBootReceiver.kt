package com.example.tramiteapp

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.Intent.ACTION_BOOT_COMPLETED
import android.util.Log
import android.os.Build

class StartMyServiceAtBootReceiver : BroadcastReceiver() {


    override fun onReceive(contxt: Context, intent: Intent) {

        when (intent?.action) {
            ACTION_BOOT_COMPLETED -> startWork(contxt,intent)
        }
    }

    private fun startWork(context: Context, intent: Intent) {
            val intent = Intent(context, BackgroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
            Log.i("Autostart", "started")
    }
}