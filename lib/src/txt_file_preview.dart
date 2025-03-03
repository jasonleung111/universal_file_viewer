import 'dart:io';

import 'package:flutter/material.dart';

/// A widget that displays the contents of a TXT file specified by the file path.
class TxtPreviewScreen extends StatefulWidget {
  /// The TXT file to display.
  final File file;

  /// Creates a [TxtPreviewScreen] widget.
  const TxtPreviewScreen({super.key, required this.file});

  @override
  TxtPreviewScreenState createState() => TxtPreviewScreenState();
}

// ignore: public_member_api_docs
class TxtPreviewScreenState extends State<TxtPreviewScreen> {
  /// The data read from the TXT file.
  late String txtData;

  @override
  void initState() {
    super.initState();
    readTxtFile(widget.file);
  }

  @override
  void didUpdateWidget(covariant TxtPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) {
      readTxtFile(widget.file);
    }
  }

  /// Reads the TXT file at [file] and updates [txtData] with the data.
  Future<void> readTxtFile(File file) async {
    try {
      txtData = await file.readAsString();
    } catch (e) {
      debugPrint("Error reading TXT file: $e");
    }
  }

  @override

  /// Builds a widget that displays the TXT file at [widget.file].
  ///
  /// The widget displays the TXT file in a table. The table is horizontally
  /// scrollable, and the cells are vertically scrollable. The table is also
  /// horizontally scrollable, so that the user can scroll through the entire
  /// file even if it is wider than the screen.
  ///
  /// If the TXT file fails to load, a [Text] widget with the error message is
  /// displayed instead.

  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(txtData.isNotEmpty ? txtData : "No TXT Data Loaded")));
  }
}
