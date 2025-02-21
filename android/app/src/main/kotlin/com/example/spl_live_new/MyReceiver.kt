package com.example.spllive

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import android.content.pm.PackageInstaller

class MyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent == null) {
            Log.e("INSTALL_APK", "❌ Received null intent in MyReceiver")
            return
        }

        val status = intent.getIntExtra(PackageInstaller.EXTRA_STATUS, -1)
        val message = intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: "Unknown error"

        when (status) {
            PackageInstaller.STATUS_SUCCESS -> {
                Log.i("INSTALL_APK", "✅ Installation successful!")
            }
            PackageInstaller.STATUS_PENDING_USER_ACTION -> {
                val activityIntent = intent.getParcelableExtra<Intent>(Intent.EXTRA_INTENT)
                activityIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context?.startActivity(activityIntent)
            }
            else -> {
                Log.e("INSTALL_APK", "❌ Installation failed: $message")
            }
        }
    }


}
