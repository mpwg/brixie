package eu.mpwg.brixie.shared.api

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
    android.util.Log.v(tag, message)
}

/**
 * Android-specific API key retrieval
 */
actual fun getApiKey(): String {
    // This will be set by the Android app module via system properties
    return System.getProperty("rebrickable.api.key") ?: "your_api_key_here"
}

/**
 * Android-specific debug flag
 */
actual fun isDebugMode(): Boolean {
    // This will be set by the Android app module via system properties
    return System.getProperty("rebrickable.debug.mode")?.toBoolean() ?: false
}