package eu.mpwg.brixie.shared.api

import android.util.Log
import eu.mpwg.android.BuildConfig
import io.ktor.client.engine.HttpClientEngine
import io.ktor.client.engine.android.Android

/**
 * Android-specific HTTP client engine
 */
actual fun createHttpClientEngine(): HttpClientEngine = Android.create()

/**
 * Android-specific logging implementation
 */
actual fun platformLog(tag: String, message: String) {
    Log.v(tag, message)
}

/**
 * Android-specific API key retrieval
 */
actual fun getApiKey(): String {
    return BuildConfig.REBRICKABLE_API_KEY
}

/**
 * Android-specific debug flag
 */
actual fun isDebugMode(): Boolean {
    return BuildConfig.DEBUG
}