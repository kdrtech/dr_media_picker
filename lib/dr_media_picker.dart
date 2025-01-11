// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:flutter/foundation.dart';

import 'dr_media_picker_platform_interface.dart';
import 'package:flutter/services.dart';

import 'model/DRPhoto.dart';
import 'model/DRVideo.dart';

class DrMediaPicker {
  static const MethodChannel _channel = MethodChannel('dr_media_picker');
  Future<String?> getPlatformVersion() {
    return DrMediaPickerPlatform.instance.getPlatformVersion();
  }

  static Future<void> config(
      {String btnSetting = "Open Settings",
      String btnCancel = "Cancel",
      String pemissionTitle = "Permission Required",
      String pemissionMessage =
          "We need access to your photos to proceed. Please enable permissions in the app settings."}) async {
    try {
      Map<String, dynamic> data = {};
      data["pemission_title"] = pemissionTitle;
      data["btn_setting"] = pemissionTitle;
      data["btn_cancel"] = pemissionTitle;
      data["pemission_message"] = pemissionMessage;
      await _channel.invokeMethod('onConfig', data);
    } catch (e) {
      print("Error sending data: $e");
    }
  }

  static Future<DRPhotoResult?> pickPhoto() async {
    try {
      final result = await _channel.invokeMethod('pickPhoto');
      final item = Map<String, dynamic>.from(result);
      final drITem = DRPhotoResult(
        path: item["path"],
        name: item["name"],
        mediaType: item["media_type"],
        mineType: item["mine_type"],
        extension: item["extension"],
      );
      return drITem;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick photo: '${e.message}'.");
        return null;
      }
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllImages() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getAllImages');
      return result.cast<Map<String, dynamic>>();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick photo: '${e.message}'.");
        return List.empty();
      }
    }
    return List.empty();
  }

  static Future<DRVideoResult?> pickVideo() async {
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
