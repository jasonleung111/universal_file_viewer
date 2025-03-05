import 'dart:io';

import 'package:excel/excel.dart' as exc;
import 'package:flutter/foundation.dart'; // Import compute()
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays the contents of an Excel file specified by the file path.
///
/// The widget reads the Excel file and displays its contents in a table.
class ExcelPreviewScreen extends StatefulWidget {
  /// The Excel file to display.
  final File file;

  /// Creates a [ExcelPreviewScreen] widget.
  const ExcelPreviewScreen({super.key, required this.file});

  @override
  ExcelPreviewScreenState createState() => ExcelPreviewScreenState();
}

// ignore: public_member_api_docs
class ExcelPreviewScreenState extends State<ExcelPreviewScreen> {
  final ScrollController _verticalController = ScrollController();

  /// The data read from the Excel file.
  late final Future<List<List<String>>> _excelData;

  @override
  void initState() {
    super.initState();
    _excelData = readExcelFile(widget.file);
  }

  @override
  void dispose() {
    super.dispose();
    _verticalController.dispose();
  }

  @override
  void didUpdateWidget(covariant ExcelPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) {
      _excelData = readExcelFile(widget.file);
    }
  }

  /// Reads the Excel file and processes it in the background using `compute()`.
  Future<List<List<String>>> readExcelFile(File file) async {
    try {
      Uint8List fileBytes = await file.readAsBytes(); // ✅ Read file bytes in the main thread
      if (kIsWeb) {
        return parseExcelData(fileBytes); // ✅ Runs synchronously on Web
      } else {
        return await compute(parseExcelData, fileBytes); // ✅ Uses compute() on Android & iOS
      }
    } catch (e) {
      debugPrint("Error reading Excel file: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _verticalController,
          padding: const EdgeInsets.only(bottom: 68),
          child: FutureBuilder<List<List<String>>>(
            future: _excelData,
            builder: (BuildContext context, AsyncSnapshot<List<List<String>>> snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: snapshot.hasData
                    ? Theme(
                        data: Theme.of(context).copyWith(cardTheme: const CardTheme(elevation: 0)),
                        child: PaginatedDataTable(
                          columns: <DataColumn>[
                            const DataColumn(label: Text("  ")),
                            ...snapshot.requireData.first.map(
                              (String header) => DataColumn(
                                label: Text(header == 'null' ? '' : header, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                          source: _ExcelDataSource(snapshot.requireData.sublist(1)),
                          rowsPerPage: 100,
                          showFirstLastButtons: true,
                          showEmptyRows: true,
                          dataRowMinHeight: 0,
                          dataRowMaxHeight: 40,
                          headingRowHeight: 40,
                          columnSpacing: 16,
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: 100,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 2,
                        ),
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (_, __) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(color: Colors.white),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ExcelDataSource extends DataTableSource {
  final List<List<String>> data;

  _ExcelDataSource(this.data);

  @override
  DataRow getRow(int index) {
    if (index >= data.length) return const DataRow(cells: <DataCell>[]);

    return DataRow(
      cells: <DataCell>[
        _buildDataCell((index + 1).toString(), isHeader: true),
        ...data[index].map((String cell) => _buildDataCell(cell)),
      ],
    );
  }

  DataCell _buildDataCell(String text, {bool isHeader = false}) =>
      DataCell(Text(text == 'null' ? '' : text, style: TextStyle(fontWeight: isHeader ? FontWeight.w300 : FontWeight.normal)));

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

/// ✅ Background isolate function to parse Excel data
List<List<String>> parseExcelData(Uint8List fileBytes) {
  final exc.Excel excel = exc.Excel.decodeBytes(fileBytes);
  final List<List<String>> extractedData = <List<String>>[];

  for (String table in excel.tables.keys) {
    for (List<exc.Data?> row in excel.tables[table]!.rows) {
      extractedData.add(
        row.map((exc.Data? cell) => cell?.value?.toString() ?? "").toList(), // ✅ Extract only Strings
      );
    }
  }

  return extractedData;
}
