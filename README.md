<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# dr_media_picker

[![Pub Package](https://img.shields.io/pub/v/dr_media_picker.svg?style=flat-square)](https://pub.dev/packages/dr_media_picker)

<a  href="https://www.buymeacoffee.com/kdrtech" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="41" />
</a>

Highly video, feature-packed dr_media_picker.

| ![Image](https://raw.githubusercontent.com/kdrtech/dr_media_picker/master/example/assets/dummy/screen-v1.0.0.gif)
| :------------: |
| **IOS** |
| ![Image](https://raw.githubusercontent.com/kdrtech/dr_media_picker/master/example/assets/dummy/screen-v1.0.0-android.gif)
| :------------: |
| **Andoid** |

## Current Features

* Image picker

## Usage

Make sure to check out [examples](https://github.com/kdrtech/dr_media_picker/tree/master/example/lib)

### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  dr_media_picker: ^1.0.1
```
### Basic setup permission 

### Permission setup
- IOS -> Add to Info.plist
```dar
<key>NSDocumentDirectoryUsageDescription</key>
<string>Your app requires access to the document directory.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>App needs access to your photo library</string>
```
- Android -> Add to AndroidManifest.xml
```dar
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" /> 
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```
### Basic Using
*The complete example is available [here](https://github.com/kdrtech/dr_media_picker/tree/master/example/lib).*
- import dependency maker you already flutter pub get
```dart
import 'package:dr_media_picker/dr_media_picker.dart';
```
- Request image
```dart
 void pickPhoto() async {
    final photoPath = await DrMediaPicker.pickPhoto();
    var path = photoPath?.path;
    var name = photoPath?.name;
    var extension = photoPath?.extension;
    var mediaType = photoPath?.mediaType;
    if (kDebugMode) {
      print("Photo Path: $path  $name  $extension $mediaType");
    }
```
### Mote ios only support custom permission dialog 
```dart
 void pickPhoto() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DrMediaPicker.config(
        pemissionMessage: "We need access your photo and video.",
        pemissionTitle: "Setting");
    runApp(const MyApp());
 }
```
### Model
```dart
class DRPhotoResult {
  String path;
  String name;
  String extension;
  String mineType;
  String mediaType;
  DRPhotoResult({
    this.path = "",
    this.name = "",
    this.mineType = "",
    this.extension = "",
    this.mediaType = "",
  });
}
```
- path : File path
- name : File name
- extension file extension
- mineType :  mine of image type
- mediaType " type of media request

### Will suport video and multiple select next version stay tuned. 

Hello everyone 👋

If you want to support me, feel free to do so. 

Thanks

============================================

សួស្ដី អ្នកទាំងអស់គ្នា👋 

បើ​អ្នក​ចង់​គាំទ្រ​ខ្ញុំ សូម​ធ្វើ​ដោយ​សេរី , 

សូមអរគុណ

<a  href="https://www.buymeacoffee.com/kdrtech" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="41" />
</a>

