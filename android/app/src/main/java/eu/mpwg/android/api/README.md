# Rebrickable API Client for Android

This module provides a comprehensive Kotlin client for interacting with the [Rebrickable API v3](https://rebrickable.com/api/v3/docs/). It includes type-safe data models, proper error handling, and coroutine support for asynchronous operations.

## Features

- 🔍 **Search LEGO Sets and Parts** - Find sets and parts by name, theme, year, or other criteria
- 📦 **Get Detailed Information** - Retrieve comprehensive details for specific sets and parts
- 🎨 **Browse Themes and Colors** - Access all available LEGO themes and colors
- ⚡ **Kotlin Coroutines** - Fully asynchronous with proper coroutine support
- 🛡️ **Type Safety** - Strongly typed data models with kotlinx.serialization
- 🚨 **Error Handling** - Comprehensive exception hierarchy for different error types
- 📱 **Android Optimized** - Uses Ktor Android engine for optimal performance

## Setup

### 1. API Key Configuration

The API client requires a Rebrickable API key. You can get one by registering at [rebrickable.com/api](https://rebrickable.com/api/).

For local development, set the `REBRICKABLE_API_KEY` environment variable:

```bash
export REBRICKABLE_API_KEY="your_api_key_here"
```

For production builds, the API key is automatically injected from the `API_KEY_REBRICKABLE` GitHub repository secret.

### 2. Dependencies

The following dependencies are included automatically:

- **Ktor** 3.0.2 - HTTP client with Android engine
- **kotlinx.serialization** 1.7.3 - JSON serialization
- **kotlinx.coroutines** 1.9.0 - Coroutine support

## Usage

### Basic Usage

```kotlin
import eu.mpwg.android.api.RebrickableApi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

// Get the singleton API client instance
val apiClient = RebrickableApi.getInstance()

// Or create a custom instance with a specific API key
val customClient = RebrickableApi.createInstance("your_custom_api_key")
```

### Searching for LEGO Sets

```kotlin
CoroutineScope(Dispatchers.Main).launch {
    val result = apiClient.getSets(
        search = "technic",
        page = 1,
        pageSize = 20,
        minYear = 2020,
        maxYear = 2024
    )
    
    result.fold(
        onSuccess = { response ->
            println("Found ${response.count} sets")
            response.results.forEach { set ->
                println("${set.name} (${set.year}) - ${set.numParts} parts")
            }
        },
        onFailure = { exception ->
            println("Error: ${exception.message}")
        }
    )
}
```

### Getting Set Details

```kotlin
CoroutineScope(Dispatchers.Main).launch {
    val result = apiClient.getSet("8880-1") // Technic Super Car
    
    result.fold(
        onSuccess = { set ->
            println("Set: ${set.name}")
            println("Year: ${set.year}")
            println("Parts: ${set.numParts}")
            println("Theme ID: ${set.themeId}")
        },
        onFailure = { exception ->
            when (exception) {
                is NotFoundException -> println("Set not found")
                is AuthenticationException -> println("Invalid API key")
                else -> println("Error: ${exception.message}")
            }
        }
    )
}
```

### Searching for Parts

```kotlin
CoroutineScope(Dispatchers.Main).launch {
    val result = apiClient.getParts(
        search = "brick",
        page = 1,
        pageSize = 10
    )
    
    result.fold(
        onSuccess = { response ->
            response.results.forEach { part ->
                println("${part.name} (${part.partNum})")
            }
        },
        onFailure = { exception ->
            println("Failed to search parts: ${exception.message}")
        }
    )
}
```

### Getting Themes and Colors

```kotlin
// Get LEGO themes
val themesResult = apiClient.getThemes(page = 1, pageSize = 50)
themesResult.onSuccess { response ->
    response.results.forEach { theme ->
        println("Theme: ${theme.name} (ID: ${theme.id})")
    }
}

// Get LEGO colors
val colorsResult = apiClient.getColors(page = 1, pageSize = 100)
colorsResult.onSuccess { response ->
    response.results.forEach { color ->
        println("${color.name}: #${color.rgb} (Transparent: ${color.isTrans})")
    }
}
```

## Data Models

### LegoSet
```kotlin
data class LegoSet(
    val setNum: String,        // e.g., "8880-1"
    val name: String,          // e.g., "Technic Super Car"
    val year: Int,             // e.g., 1994
    val themeId: Int,          // Theme category ID
    val numParts: Int,         // Number of parts in set
    val setImgUrl: String?,    // URL to set image
    val setUrl: String?,       // URL to Rebrickable page
    val lastModifiedDt: String // Last modification timestamp
)
```

### LegoPart
```kotlin
data class LegoPart(
    val partNum: String,               // e.g., "3001"
    val name: String,                  // e.g., "Brick 2 x 4"
    val partCatId: Int,                // Part category ID
    val partUrl: String?,              // URL to part page
    val partImgUrl: String?,           // URL to part image
    val externalIds: Map<String, List<String>>?, // External IDs
    val printOf: String?               // Parent part if this is a print
)
```

### LegoTheme
```kotlin
data class LegoTheme(
    val id: Int,           // Theme ID
    val name: String,      // Theme name
    val parentId: Int?     // Parent theme ID (if sub-theme)
)
```

### LegoColor
```kotlin
data class LegoColor(
    val id: Int,           // Color ID
    val name: String,      // Color name
    val rgb: String,       // RGB hex code
    val isTrans: Boolean   // Whether color is transparent
)
```

## Error Handling

The API client provides a comprehensive exception hierarchy:

- **`RebrickableApiException`** - Base exception class
- **`NetworkException`** - Network connectivity issues
- **`AuthenticationException`** - Invalid or missing API key
- **`NotFoundException`** - Requested resource not found
- **`BadRequestException`** - Invalid request parameters
- **`RateLimitException`** - API rate limit exceeded
- **`ServerException`** - Server-side errors
- **`ParseException`** - JSON parsing errors

```kotlin
result.fold(
    onSuccess = { data -> /* handle success */ },
    onFailure = { exception ->
        when (exception) {
            is AuthenticationException -> {
                // Handle authentication error
                // Maybe redirect to settings or show API key dialog
            }
            is NetworkException -> {
                // Handle network error
                // Maybe show retry button or offline message
            }
            is RateLimitException -> {
                // Handle rate limiting
                // Maybe implement exponential backoff
            }
            else -> {
                // Handle other errors
                // Maybe show generic error message
            }
        }
    }
)
```

## Rate Limiting

The Rebrickable API has rate limits. The client automatically handles rate limit responses with `RateLimitException`. In your app, you should implement proper retry logic with exponential backoff when encountering rate limits.

## Testing

The module includes comprehensive unit tests. Run them with:

```bash
./gradlew test
```

Test files include:
- `RebrickableApiClientTest.kt` - Basic functionality and model tests
- Example usage in `RebrickableApiExample.kt`

## Example Integration

See `RebrickableApiExample.kt` for complete examples of how to integrate the API client into your app, including proper error handling and coroutine usage.

## License

This module is part of the Brixie project and is licensed under the AGPL-3.0 license.