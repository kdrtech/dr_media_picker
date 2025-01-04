import 'package:flutter_test/flutter_test.dart';
import 'package:dr_media_picker/dr_media_picker.dart';
import 'package:dr_media_picker/dr_media_picker_platform_interface.dart';
import 'package:dr_media_picker/dr_media_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDrMediaPickerPlatform
    with MockPlatformInterfaceMixin
    implements DrMediaPickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DrMediaPickerPlatform initialPlatform = DrMediaPickerPlatform.instance;

  test('$MethodChannelDrMediaPicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDrMediaPicker>());
  });

  test('getPlatformVersion', () async {
    DrMediaPicker drMediaPickerPlugin = DrMediaPicker();
    MockDrMediaPickerPlatform fakePlatform = MockDrMediaPickerPlatform();
    DrMediaPickerPlatform.instance = fakePlatform;

    expect(await drMediaPickerPlugin.getPlatformVersion(), '42');
  });
}
