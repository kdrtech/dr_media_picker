// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:flutter/foundation.dart';

import 'dr_media_picker_platform_interface.dart';
import 'package:flutter/services.dart';

class DrMediaPicker {
  static const MethodChannel _channel = MethodChannel('dr_media_picker');
  Future<String?> getPlatformVersion() {
    return DrMediaPickerPlatform.instance.getPlatformVersion();
  }

  static Future<String?> pickPhoto() async {
    try {
      return await _channel.invokeMethod('pickPhoto');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick photo: '${e.message}'.");
        return null;
      }
    }
    return null;
  }

  static Future<String?> pickVideo() async {
    try {
      return await _channel.invokeMethod('pickVideo');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick photo: '${e.message}'.");
        return null;
      }
    }
    return null;
  }
}
