import 'dart:io';

import 'package:flutter/material.dart';

/// A widget that displays the contents of a text file specified by the file path.
class TextPreviewScreen extends StatefulWidget {
  /// The text file path to display.
  final String filePath;

  /// Creates a [TextPreviewScreen] widget.
  const TextPreviewScreen({super.key, required this.filePath});

  @override
  TextPreviewScreenState createState() => TextPreviewScreenState();
}

// ignore: public_member_api_docs
class TextPreviewScreenState extends State<TextPreviewScreen> {
  /// The data read from the text file.
  String textData = "";

  @override
  void initState() {
    super.initState();
    _readTextFile();
  }

  @override
  void didUpdateWidget(covariant TextPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _readTextFile();
    }
  }

  /// Reads the text file at [widget.filePath] and updates [textData] with the data.
  ///
  /// This function reads the contents of a text file at the file path specified
  /// by [widget.filePath] and updates the [textData] field with the contents of
  /// the file. It is called when the [TextPreviewScreen] widget is created or
  /// updated with a new file path, and it is also called when the text file is
  /// first created, as part of the [initState] method.
  ///
  /// If the file is not found, it displays "File not found".
  ///
  /// If the file fails to load, it displays "Error reading text file: $e".
  Future<void> _readTextFile() async {
    try {
      final File file = File(widget.filePath);
      if (await file.exists()) {
        final String data = await file.readAsString();
        setState(() {
          textData = data;
        });
      } else {
        setState(() {
          textData = "File not found";
        });
      }
    } catch (e) {
      setState(() {
        textData = "Error reading text file: $e";
      });
    }
  }

  @override

  /// Builds the widget tree for displaying the content of a text file.
  ///
  /// This widget shows an [AppBar] with the title "text Preview" and a body
  /// containing the contents of the text file. The body is wrapped in a
  /// [SingleChildScrollView] to allow scrolling if the content is extensive.
  /// If the text file data is empty, it displays "No text Data Loaded".

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(textData.isNotEmpty ? textData : "No text Data Loaded"),
        ),
      ),
    );
  }
}
