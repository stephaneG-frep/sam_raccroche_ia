package com.samraccroche.ia

import android.telecom.Call
import android.telecom.InCallService

class SamInCallService : InCallService() {
    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        // MVP: Android exige souvent un InCallService pour etre eligible au role Dialer.
        // L'interface d'appel complete sera implementee dans une prochaine iteration.
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
    }
}
