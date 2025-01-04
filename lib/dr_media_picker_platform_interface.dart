import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dr_media_picker_method_channel.dart';

abstract class DrMediaPickerPlatform extends PlatformInterface {
  /// Constructs a DrMediaPickerPlatform.
  DrMediaPickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DrMediaPickerPlatform _instance = MethodChannelDrMediaPicker();

  /// The default instance of [DrMediaPickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDrMediaPicker].
  static DrMediaPickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DrMediaPickerPlatform] when
  /// they register themselves.
  static set instance(DrMediaPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
