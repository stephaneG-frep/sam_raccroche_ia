package com.samraccroche.ia

import android.content.Context
import android.telecom.Call
import android.telecom.CallScreeningService
import org.json.JSONArray
import org.json.JSONObject

class SamCallScreeningService : CallScreeningService() {
    private val prefsName = "sam_raccroche_ia_native_rules"

    override fun onScreenCall(callDetails: Call.Details) {
        val rules = readRules()
        val number = normalize(callDetails.handle?.schemeSpecificPart)
        val shouldReject = shouldReject(number, rules)

        val response = if (shouldReject) {
            CallResponse.Builder()
                .setDisallowCall(true)
                .setRejectCall(true)
                .setSkipCallLog(false)
                .setSkipNotification(false)
                .build()
        } else {
            CallResponse.Builder().build()
        }

        respondToCall(callDetails, response)
    }

    private fun readRules(): JSONObject {
        val payload = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            .getString("rules_payload", null)
        if (payload.isNullOrBlank()) return JSONObject()
        return try {
            JSONObject(payload)
        } catch (_: Exception) {
            JSONObject()
        }
    }

    private fun shouldReject(number: String, rules: JSONObject): Boolean {
        val settings = rules.optJSONObject("settings") ?: JSONObject()
        if (!settings.optBoolean("protectionEnabled", true)) return false
        if (number.isBlank()) return false

        if (containsNumber(rules.optJSONArray("whitelist") ?: JSONArray(), number)) {
            return false
        }
        if (containsNumber(rules.optJSONArray("blacklist") ?: JSONArray(), number)) {
            return true
        }

        val prefixes = settings.optJSONArray("blockedPrefixes") ?: JSONArray()
        for (i in 0 until prefixes.length()) {
            val prefix = normalize(prefixes.optString(i))
            if (prefix.isNotBlank() && number.startsWith(prefix)) return true
        }
        return false
    }

    private fun containsNumber(values: JSONArray, number: String): Boolean {
        for (i in 0 until values.length()) {
            if (normalize(values.optString(i)) == number) return true
        }
        return false
    }

    private fun normalize(value: String?): String {
        return value.orEmpty().filter { it.isDigit() || it == '+' }
    }
}
