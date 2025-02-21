import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

/// A widget that displays the contents of a Word document specified by the file path.
class WordViewer extends StatefulWidget {
  /// The file path to the Word document.
  final String filePath;

  /// Creates a WordViewer widget.
  const WordViewer({super.key, required this.filePath});

  @override
  State<WordViewer> createState() => _WordViewerState();
}

class _WordViewerState extends State<WordViewer> {
  List<Widget> docxContent = <Widget>[];

  @override
  /// Initializes the state by extracting the contents of the Word document.
  ///
  /// This method is called when the widget is first created. It calls the
  /// [_extractDocxContent] method to parse and display the contents of the
  /// Word document specified by the file path.

  void initState() {
    super.initState();
    _extractDocxContent();
  }

  @override
  void didUpdateWidget(covariant WordViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  /// Called when the [WordViewer] widget is updated with a new file path.
  ///
  /// This method is called when the [WordViewer] widget is updated with a new
  /// file path. It checks if the file path has changed, and if so, it calls the
  /// [_extractDocxContent] method to parse and display the contents of the
  /// Word document at the new file path.
    if (oldWidget.filePath != widget.filePath) {
      _extractDocxContent();
    }
  }

  /// Extracts the contents of a Word document specified by the file path and
  /// displays them as a list of widgets.
  ///
  /// This method is called when the [WordViewer] widget is created or updated
  /// with a new file path. It parses the Word document and extracts its
  /// contents as a list of widgets, which are then displayed in the
  /// [WordViewer] widget.
  ///
  /// The method first reads the contents of the Word document as a list of
  /// bytes, then decodes the bytes using the [ZipDecoder] class to extract
  /// the contents of the document. The contents are then parsed as an XML
  /// document, and the text and images are extracted from it. The extracted
  /// contents are then displayed in the [WordViewer] widget as a list of
  /// [Text] and [Image] widgets.
  ///
  /// If the file path is invalid, or if the Word document is corrupted, the
  /// method displays an error message instead of the contents of the document.
  ///
  /// This method is called whenever the [WordViewer] widget is created or
  /// updated with a new file path. It is also called when the [WordViewer]
  /// widget is first created, as part of the [initState] method.
  Future<void> _extractDocxContent() async {
    setState(() => docxContent = <Widget>[]);

    try {
      final File file = File(widget.filePath);
      final Uint8List bytes = await file.readAsBytes();
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      String? documentXml;
      Map<String, Uint8List> images = <String, Uint8List>{};

      for (final ArchiveFile file in archive.files) {
        if (file.name == "word/document.xml") {
          documentXml = utf8.decode(file.content as List<int>);
        } else if (file.name.startsWith("word/media/")) {
          images[file.name] = file.content as Uint8List;
        }
      }

      if (documentXml == null) {
        setState(
            () => docxContent = <Widget>[const Text("No text found in DOCX.")]);
        return;
      }

      final XmlDocument document = XmlDocument.parse(documentXml);
      List<Widget> contentWidgets = <Widget>[];

      for (final XmlElement paragraph in document.findAllElements("w:p")) {
        List<TextSpan> spans = <TextSpan>[];
        TextAlign alignment = TextAlign.left;

        final XmlElement? alignElement = paragraph
            .findElements("w:pPr")
            .firstOrNull
            ?.findElements("w:jc")
            .firstOrNull;
        if (alignElement != null) {
          switch (alignElement.getAttribute("w:val")) {
            case "center":
              alignment = TextAlign.center;
              break;
            case "right":
              alignment = TextAlign.right;
              break;
            case "both":
              alignment = TextAlign.justify;
              break;
            default:
              alignment = TextAlign.left;
          }
        }

        for (final XmlElement run in paragraph.findAllElements("w:r")) {
          final XmlElement? textElement = run.findElements("w:t").firstOrNull;
          if (textElement == null) continue;

          String text = textElement.innerText;

          bool isBold = run.findElements("w:b").isNotEmpty;
          bool isItalic = run.findElements("w:i").isNotEmpty;
          bool isUnderline = run.findElements("w:u").isNotEmpty;
          bool isStrikethrough = run.findElements("w:strike").isNotEmpty;
          bool isSuperscript = run
              .findElements("w:vertAlign")
              .any((XmlElement e) => e.getAttribute("w:val") == "superscript");
          bool isSubscript = run
              .findElements("w:vertAlign")
              .any((XmlElement e) => e.getAttribute("w:val") == "subscript");

          double? fontSize;
          final XmlElement? fontSizeElement =
              run.findElements("w:sz").firstOrNull;
          if (fontSizeElement != null) {
            fontSize =
                double.tryParse(fontSizeElement.getAttribute("w:val") ?? "") ??
                    16;
            fontSize = fontSize / 2;
          }

          Color? fontColor;
          final XmlElement? colorElement =
              run.findElements("w:color").firstOrNull;
          if (colorElement != null) {
            final String? colorCode = colorElement.getAttribute("w:val");
            if (colorCode != null && colorCode.length == 6) {
              fontColor = Color(int.parse("0xFF$colorCode"));
            }
          }

          Color? bgColor;
          final XmlElement? shadingElement =
              run.findElements("w:shd").firstOrNull;
          if (shadingElement != null) {
            final String? fillColor = shadingElement.getAttribute("w:fill");
            if (fillColor != null && fillColor.length == 6) {
              bgColor = Color(int.parse("0xFF$fillColor"));
            }
          }

          spans.add(
            TextSpan(
              text: text,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: TextDecoration.combine(<TextDecoration>[
                  if (isUnderline) TextDecoration.underline,
                  if (isStrikethrough) TextDecoration.lineThrough,
                ]),
                fontSize: fontSize ?? 16,
                color: fontColor ?? Colors.black,
                backgroundColor: bgColor,
                fontFeatures: <FontFeature>[
                  if (isSuperscript) const FontFeature.superscripts(),
                  if (isSubscript) const FontFeature.subscripts(),
                ],
              ),
            ),
          );
        }

        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: _convertTextAlign(alignment),
              child: RichText(
                text: TextSpan(
                    children: spans,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
          ),
        );
      }

      for (MapEntry<String, Uint8List> img in images.entries) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.memory(img.value, fit: BoxFit.contain),
          ),
        );
      }

      setState(() => docxContent = contentWidgets);
    } catch (e) {
      setState(() => docxContent = <Widget>[Text("Failed to load DOCX: $e")]);
    }
  }

  /// Convert [TextAlign] to [Alignment].
  ///
  /// [TextAlign] is used in the DOCX file format, while [Alignment] is used in
  /// Flutter. This function converts between the two.
  Alignment _convertTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.justify:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  /// Builds the widget tree for a DOCX viewer.
  ///
  /// This widget displays a [CircularProgressIndicator] until the content of
  /// the DOCX file is loaded, at which point it displays the content of the
  /// file inside a [SingleChildScrollView].
  ///
  /// The content of the file is a vertical column of widgets, with each widget
  /// representing a paragraph or image from the file. The column is aligned
  /// to the left, and the widgets inside the column are also aligned to the
  /// left.
  ///
  /// If the content of the file fails to load, this widget displays a [Text]
  /// widget with the error message instead.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: docxContent.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: docxContent,
                ),
              ),
      ),
    );
  }
}
