// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';

/// A widget that displays the content of the file at [filePath].
///
/// The content is extracted from the file using the [docx_to_text] package.
/// If the extraction fails, the widget displays an error message.
class WordViewer extends StatefulWidget {
  /// The path to the file to display.
  final String filePath;
  const WordViewer({
    super.key,
    required this.filePath,
  });

  @override
  State<WordViewer> createState() => _WordViewerState();
}

class _WordViewerState extends State<WordViewer> {
  String extractedText = "";

  @override
  void initState() {
    super.initState();
    _extractTextFromDocx();
  }

  @override
  void didUpdateWidget(covariant WordViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      // Reload text if filePath has changed
      _extractTextFromDocx();
    }
  }

  Future<void> _extractTextFromDocx() async {
    setState(() => extractedText = "");
    try {
      final File file = File(widget.filePath);
      final Uint8List bytes =
          await file.readAsBytes(); // Read DOCX file as bytes
      final String text =
          docxToText(bytes, handleNumbering: true); // Extract text

      setState(() => extractedText = text);
    } catch (e) {
      setState(() => extractedText = "Failed to extract text from DOCX: $e");
    }
  }

  @override

  /// Builds the widget tree for displaying the extracted text from a DOCX file.
  ///
  /// If the `extractedText` is empty, a loading indicator is shown. Otherwise,
  /// the extracted text is displayed within a scrollable view.

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: extractedText.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Text(extractedText),
      ),
    );
  }
}
