import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

/// A widget that displays the contents of a CSV file specified by the file path.
class CsvPreviewScreen extends StatefulWidget {
  /// The CSV file to display.
  final File file;

  /// Creates a [CsvPreviewScreen] widget.
  const CsvPreviewScreen({super.key, required this.file});

  @override
  CsvPreviewScreenState createState() => CsvPreviewScreenState();
}

// ignore: public_member_api_docs
class CsvPreviewScreenState extends State<CsvPreviewScreen> {
  /// The data read from the CSV file.
  List<List<String>> csvData = <List<String>>[];

  @override
  void initState() {
    super.initState();
    readCsvFile(widget.file);
  }

  @override
  void didUpdateWidget(covariant CsvPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) {
      readCsvFile(widget.file);
    }
  }

  /// Reads the CSV file at [filePath] and updates [csvData] with the data.
  Future<void> readCsvFile(File file) async {
    try {
      String csvString = await file.readAsString();
      List<List<dynamic>> tempData = const CsvToListConverter().convert(csvString);

      setState(() {
        csvData = tempData
            // ignore: always_specify_types
            .map((List row) => row.map((cell) => cell.toString()).toList())
            .toList();
      });
    } catch (e) {
      debugPrint("Error reading CSV file: $e");
    }
  }

  @override

  /// Builds a widget that displays the CSV file at [widget.filePath].
  ///
  /// The widget displays the CSV file in a table. The table is horizontally
  /// scrollable, and the cells are vertically scrollable. The table is also
  /// horizontally scrollable, so that the user can scroll through the entire
  /// file even if it is wider than the screen.
  ///
  /// If the CSV file fails to load, a [Text] widget with the error message is
  /// displayed instead.

  Widget build(BuildContext context) {
    return Scaffold(
      body: csvData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: csvData.length,
                  itemBuilder: (_, int index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ClipRect(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: csvData[index]
                                .map((String cell) => SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(cell, overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const Center(child: Text("No CSV Data Loaded")),
    );
  }
}
