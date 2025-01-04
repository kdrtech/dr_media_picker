import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dr_media_picker_platform_interface.dart';

/// An implementation of [DrMediaPickerPlatform] that uses method channels.
class MethodChannelDrMediaPicker extends DrMediaPickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dr_media_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
