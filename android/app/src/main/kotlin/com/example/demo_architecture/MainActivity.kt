package com.example.demo_architecture

import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.get_id_device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUniqueId" -> {
                    val uniqueId = getUniqueId()
                    if (uniqueId != null) {
                        result.success(uniqueId)
                    } else {
                        result.error("UNAVAILABLE", "Unique ID not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getUniqueId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }
}