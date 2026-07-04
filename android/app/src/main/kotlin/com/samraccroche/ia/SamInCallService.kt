package com.samraccroche.ia

import android.telecom.Call
import android.telecom.InCallService

class SamInCallService : InCallService() {
    companion object {
        private val activeCalls = mutableSetOf<Call>()

        fun hangUpActiveCall(): Boolean {
            val call = activeCalls.lastOrNull() ?: return false
            return try {
                call.disconnect()
                true
            } catch (_: Exception) {
                false
            }
        }
    }

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        activeCalls.add(call)
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        activeCalls.remove(call)
    }
}
