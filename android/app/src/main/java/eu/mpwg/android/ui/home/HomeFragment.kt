package eu.mpwg.android.ui.home

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import eu.mpwg.android.api.RebrickableApi
import eu.mpwg.android.api.AuthenticationException
import eu.mpwg.android.api.NetworkException
import eu.mpwg.android.databinding.FragmentHomeBinding
import kotlinx.coroutines.launch

class HomeFragment : Fragment() {

    companion object {
        private const val TAG = "HomeFragment"
    }

    private var _binding: FragmentHomeBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val homeViewModel =
            ViewModelProvider(this).get(HomeViewModel::class.java)

        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        val root: View = binding.root

        val textView: TextView = binding.textHome
        homeViewModel.text.observe(viewLifecycleOwner) {
            textView.text = it
        }
        
        // Example: Test API client with a sample call
        // This demonstrates how to integrate the Rebrickable API in the app
        testApiClientIntegration()
        
        return root
    }

    /**
     * Example integration of the Rebrickable API client
     * This demonstrates how to use the API client in a real fragment
     */
    private fun testApiClientIntegration() {
        // Get the API client instance
        val apiClient = RebrickableApi.getInstance()
        
        // Launch a coroutine to test API connectivity
        lifecycleScope.launch {
            try {
                Log.d(TAG, "Testing Rebrickable API connection...")
                
                // Try to get a few LEGO themes to test the connection
                val result = apiClient.getThemes(page = 1, pageSize = 5)
                
                result.fold(
                    onSuccess = { response ->
                        Log.d(TAG, "✅ API connection successful! Found ${response.count} themes:")
                        response.results.take(3).forEach { theme ->
                            Log.d(TAG, "  - ${theme.name} (ID: ${theme.id})")
                        }
                        
                        // Update UI to show API is working
                        updateApiStatus("API Connected - ${response.count} themes available")
                    },
                    onFailure = { exception ->
                        Log.w(TAG, "❌ API call failed: ${exception.message}")
                        
                        val errorMessage = when (exception) {
                            is AuthenticationException -> "API Key Required - Please configure REBRICKABLE_API_KEY"
                            is NetworkException -> "Network Error - Check internet connection"
                            else -> "API Error - ${exception.message}"
                        }
                        
                        updateApiStatus(errorMessage)
                    }
                )
            } catch (e: Exception) {
                Log.e(TAG, "Unexpected error during API test", e)
                updateApiStatus("Error: ${e.message}")
            }
        }
    }
    
    /**
     * Update the HomeFragment text to show API status
     * This is just for demonstration purposes
     */
    private fun updateApiStatus(status: String) {
        binding.textHome.text = "${binding.textHome.text}\n\nRebrickable API Status:\n$status"
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}