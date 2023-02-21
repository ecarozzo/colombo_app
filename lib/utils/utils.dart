import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

showEmptyDialog(String title,BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          AlertDialog(
            content: Text("$title non può essere vuoto"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          ),
    );
  } else if (Platform.isIOS) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            content: Text("$title non può essere vuoto"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          ),
    );
  }
}