package com.example.zed_store_mangent

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // السطر ده هو اللي بيخلي flutter_link و getInitialLink يشوفوا اللينك الجديد
        setIntent(intent)
    }
}