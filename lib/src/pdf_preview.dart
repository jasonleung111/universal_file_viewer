import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String filePath;

  const PdfPreviewScreen({super.key, required this.filePath});

  @override
  PdfPreviewScreenState createState() => PdfPreviewScreenState();
}

class PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfControllerPinch? _pdfController;
  bool _isFileAvailable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  void didUpdateWidget(covariant PdfPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _loadPdf();
    }
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
    });

    final File file = File(widget.filePath);
    if (await file.exists()) {
      final PdfControllerPinch newController = PdfControllerPinch(
        document: PdfDocument.openFile(widget.filePath),
      );

      // Delay disposal to avoid UI issues.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pdfController?.dispose();
        setState(() {
          _pdfController = newController;
          _isFileAvailable = true;
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isFileAvailable = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isFileAvailable && _pdfController != null
              ? PdfViewPinch(controller: _pdfController!)
              : const Center(child: Text("File not found")),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
