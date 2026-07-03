package com.samraccroche.ia

import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.telecom.TelecomManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "sam_raccroche_ia/calls"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "isDefaultDialer" -> result.success(isDefaultDialer())
                "requestDefaultDialerRole" -> result.success(requestDefaultDialerRole())
                "openDefaultAppsSettings" -> result.success(openDefaultAppsSettings())
                "hangUp" -> result.success(false)
                else -> result.notImplemented()
            }
        }
    }

    private fun isDefaultDialer(): Boolean {
        val telecom = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
        return packageName == telecom.defaultDialerPackage
    }

    private fun requestDefaultDialerRole(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(RoleManager::class.java)
            if (roleManager.isRoleAvailable(RoleManager.ROLE_DIALER) && !roleManager.isRoleHeld(RoleManager.ROLE_DIALER)) {
                startActivityForResult(roleManager.createRequestRoleIntent(RoleManager.ROLE_DIALER), 42)
                return true
            }
            return isDefaultDialer()
        } else {
            val intent = Intent(TelecomManager.ACTION_CHANGE_DEFAULT_DIALER)
            intent.putExtra(TelecomManager.EXTRA_CHANGE_DEFAULT_DIALER_PACKAGE_NAME, packageName)
            startActivity(intent)
            return true
        }
    }

    private fun openDefaultAppsSettings(): Boolean {
        return try {
            startActivity(Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS))
            true
        } catch (_: Exception) {
            false
        }
    }
}
