import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dr_media_picker/dr_media_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DrMediaPicker.config(
      pemissionMessage: "We need access your photo and video.",
      pemissionTitle: "Setting");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _drMediaPickerPlugin = DrMediaPicker();
  String? _imageFile;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _drMediaPickerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void pickPhoto() async {
    final photoPath = await DrMediaPicker.pickPhoto();
    var path = photoPath?.path;
    var name = photoPath?.name;
    var extension = photoPath?.extension;
    var mediaType = photoPath?.mediaType;
    if (kDebugMode) {
      print("Photo Path: $path  $name  $extension $mediaType");
    }
    setState(() {
      _imageFile = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Photo Picker'),
        ),
        body: Center(
          child: Column(children: [
            Text('Running on: $_platformVersion\n'),
            OutlinedButton(
              onPressed: () => {pickPhoto()},
              child: const Text("Pick Photo"),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: _imageFile != null
                    ? Image.file(
                        File(_imageFile!),
                        height: 500,
                      )
                    : Container(
                        height: 500,
                        alignment: Alignment.center,
                        child: const Text("No image"),
                      )),
          ]),
        ),
      ),
    );
  }
}
