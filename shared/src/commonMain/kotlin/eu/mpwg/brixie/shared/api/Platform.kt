package eu.mpwg.brixie.shared.api

import io.ktor.client.engine.HttpClientEngine

/**
 * Platform-specific HTTP client engine
 */
expect fun createHttpClientEngine(): HttpClientEngine

/**
 * Platform-specific logging implementation
 */
expect fun platformLog(tag: String, message: String)

/**
 * Platform-specific API key retrieval
 */
expect fun getApiKey(): String

/**
 * Platform-specific debug flag
 */
expect fun isDebugMode(): Boolean