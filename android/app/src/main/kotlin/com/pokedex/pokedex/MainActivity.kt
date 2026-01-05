package com.pokedex

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.firebase.analytics.FirebaseAnalytics
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.pokedex"
    private lateinit var firebaseAnalytics: FirebaseAnalytics

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        firebaseAnalytics = FirebaseAnalytics.getInstance(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "logEvent" -> {
                    val name = call.argument<String>("name") ?: "event_without_name"
                    val paramsMap = call.argument<Map<String, Any>>("params") ?: emptyMap()

                    val bundle = Bundle()
                    paramsMap.forEach { (key, value) ->
                        when (value) {
                            is String -> bundle.putString(key, value)
                            is Int -> bundle.putInt(key, value)
                            is Long -> bundle.putLong(key, value)
                            is Double -> bundle.putDouble(key, value)
                            is Boolean -> bundle.putBoolean(key, value)
                            else -> bundle.putString(key, value.toString())
                        }
                    }

                    firebaseAnalytics.logEvent(name, bundle)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
