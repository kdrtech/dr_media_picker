import io.flutter.embedding.android.FlutterActivity
import android.widget.Toast
class MainActivity : FlutterActivity() {
    private var plugin: DrMediaPickerPlugin

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // Pass the MainActivity instance to the plugin
        //plugin = DrMediaPickerPlugin(this)
         Toast.makeText(this, "data", Toast.LENGTH_LONG).show();
    }
}
