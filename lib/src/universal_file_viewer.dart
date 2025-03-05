// ignore_for_file: always_specify_types, public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:universal_file_viewer/src/excel_csv_file_preview.dart';
import 'package:universal_file_viewer/src/txt_file_preview.dart';
import 'package:universal_file_viewer/src/word_file_preview.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

import 'md_file_preview.dart';

class UniversalFileViewer extends StatelessWidget {
  final File file;

  const UniversalFileViewer({super.key, required this.file});

  /// Builds a widget that displays the file at [file].
  ///
  /// The widget depends on the type of the file. If the file is an image, video,
  /// or PDF, a widget is returned that displays the file directly. Otherwise, a
  /// button is returned that opens the file in an external application when
  /// pressed.
  @override
  Widget build(BuildContext context) {
    if (supportedFile(file.path)) {
      final fileType = detectFileType(file.path)!;
      switch (fileType) {
        case FileType.image:
          return Center(child: Image.file(file));
        case FileType.video:
          return VideoPlayerWidget(file: file);
        case FileType.pdf:
          return PdfViewer.file(file.path);
        case FileType.word:
          return DocxToFlutter(file: file);
        case FileType.excel:
          return ExcelCSVPreviewScreen(file: file);
        case FileType.csv:
          return ExcelCSVPreviewScreen(file: file);
        case FileType.text:
          return TxtPreviewScreen(file: file);
        case FileType.md:
          return MdPreviewScreen(file: file);
      }
    } else {
      return const Center(
        child: Text('File type not supported'),
      );
    }
  }
}
