package com.morecambodia.dr_media_picker


import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.embedding.android.FlutterActivity
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class DrMediaPickerPlugin : FlutterPlugin,
    MethodChannel.MethodCallHandler,
    PluginRegistry.ActivityResultListener,
    PluginRegistry.RequestPermissionsResultListener,
    ActivityAware {
    private lateinit var imagePickerLauncher: ActivityResultLauncher<Intent>
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null
    private var context: Context? = null
    private var pendingResult: MethodChannel.Result? = null
    private var currentRequest: String? = null

    companion object {
        private const val REQUEST_PICK_IMAGE = 1001
        private const val REQUEST_PICK_VIDEO = 1002
        private const val REQUEST_PERMISSIONS = 2001
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(object : PluginRegistry.ActivityResultListener {
            override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
                // Handle result here
                Toast.makeText(context!!, ""+requestCode, Toast.LENGTH_LONG).show();
                if (requestCode == REQUEST_PICK_IMAGE) {
                    if (resultCode == Activity.RESULT_OK) {
                        // Handle the result
                        return true
                    }
                }
                return false
            }
        })
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            if (requestCode == REQUEST_PICK_IMAGE) {
                // Handle permissions
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission granted
                    true
                } else {
                    // Permission denied
                    false
                }
            } else {
                false
            }
        }
//        (binding.activity as PluginRegistry.MainActivity).registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
//            //onActivityResult(result.resultCode, result.resultCode, result.data)
//        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        //context = binding.applicationContext
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dr_media_picker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

    }

    fun setActivity(activity: Activity) {
        //this.activity = activity
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {

        when (call.method) {
            "pickPhoto" -> checkAndRequestPermissions(result,
                REQUEST_PICK_IMAGE
            )
            "pickVideo" -> checkAndRequestPermissions(result,
                REQUEST_PICK_VIDEO
            )
            "getPlatformVersion" -> getPlatformVersion(result)
        
            else -> result.notImplemented()
        }
    }
    private fun getPlatformVersion(result: MethodChannel.Result) { 
        result.success("Android " + Build.VERSION.RELEASE);
    }
    private fun checkAndRequestPermissions(result: MethodChannel.Result, requestType: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this.context!!, android.Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                CoroutineScope(Dispatchers.IO).launch {
                    ActivityCompat.requestPermissions(
                        activity!!, arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE),
                        REQUEST_PERMISSIONS
                    )
                    currentRequest = if (requestType == REQUEST_PICK_IMAGE) "image" else "video"
                    pendingResult = result
                    return@launch
                }
            }
        }
        Toast.makeText(context, "end", Toast.LENGTH_LONG).show()
        startPicker(requestType)
    }

    private fun startPicker(requestType: Int) {
        Toast.makeText(context!!, "startPicker", Toast.LENGTH_LONG).show();
        val intent = Intent(Intent.ACTION_PICK)
        intent.type = if (requestType == REQUEST_PICK_IMAGE) "image/*" else "video/*"
        this.activity!!.startActivityForResult(intent, requestType)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Toast.makeText(context!!, "data", Toast.LENGTH_LONG).show();
        if (pendingResult == null) return false

        if (resultCode == Activity.RESULT_OK && data != null) {
            val uri: Uri? = data.data
            Toast.makeText(context!!, ""+uri, Toast.LENGTH_LONG).show();
            if (uri != null) {
                val resultData = mapOf(
                    "path" to uri.toString(),
                    "type" to if (requestCode == REQUEST_PICK_IMAGE) "photo" else "video"
                )
                pendingResult?.success(resultData)
            } else {
                pendingResult?.error("ERROR", "Media not found", null)
            }
        } else {
            pendingResult?.error("CANCELLED", "User cancelled the operation", null)
        }
        pendingResult = null
        return true
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (currentRequest == "image") {
                    startPicker(REQUEST_PICK_IMAGE)
                } else if (currentRequest == "video") {
                    startPicker(REQUEST_PICK_VIDEO)
                }
            } else {
                pendingResult?.error("PERMISSION_DENIED", "Storage access permission denied", null)
                pendingResult = null
            }
            return true
        }
        return false
    }
}
