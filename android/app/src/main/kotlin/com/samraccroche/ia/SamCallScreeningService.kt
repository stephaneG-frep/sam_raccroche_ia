package com.samraccroche.ia

import android.telecom.Call
import android.telecom.CallScreeningService

class SamCallScreeningService : CallScreeningService() {
    override fun onScreenCall(callDetails: Call.Details) {
        respondToCall(callDetails, CallResponse.Builder().build())
    }
}
