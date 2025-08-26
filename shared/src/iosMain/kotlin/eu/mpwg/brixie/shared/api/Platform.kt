package eu.mpwg.brixie.shared.api

import io.ktor.client.engine.HttpClientEngine
import io.ktor.client.engine.darwin.Darwin
import platform.Foundation.NSLog

/**
 * iOS-specific HTTP client engine
 */
actual fun createHttpClientEngine(): HttpClientEngine = Darwin.create()

/**
 * iOS-specific logging implementation
 */
actual fun platformLog(tag: String, message: String) {
    NSLog("[$tag] $message")
}

/**
 * iOS-specific API key retrieval
 * Note: This will need to be configured to get the API key from bundle or environment
 */
actual fun getApiKey(): String {
    // This will be set by the iOS app
    return "your_api_key_here" // TODO: Configure API key for iOS
}

/**
 * iOS-specific debug flag
 */
actual fun isDebugMode(): Boolean {
    // This will be set by the iOS app
    return false // TODO: Configure debug mode for iOS
}