import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';

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
  List<List<String>> excelData = <List<String>>[];

  @override
  void initState() {
    super.initState();
    readExcelFile(widget.file);
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
      readExcelFile(widget.file);
    }
  }

  /// Reads the Excel file at [file] and updates [excelData] with the data from the file.
  Future<void> readExcelFile(File file) async {
    try {
      Uint8List fileBytes = await file.readAsBytes();
      exc.Excel excel = exc.Excel.decodeBytes(fileBytes);
      List<List<String>> tempData = <List<String>>[];

      for (String table in excel.tables.keys) {
        for (List<exc.Data?> row in excel.tables[table]!.rows) {
          tempData.add(row.map((exc.Data? cell) => cell?.value.toString() ?? "").toList());
        }
      }

      setState(() {
        excelData = tempData;
      });
    } catch (e) {
      debugPrint("Error reading Excel file: $e");
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: excelData.isNotEmpty
                ? Theme(
                    data: Theme.of(context).copyWith(cardTheme: const CardTheme(elevation: 0)),
                    child: PaginatedDataTable(
                      columns: <DataColumn>[
                        const DataColumn(label: Text("  ")),
                        ...excelData.first.map(
                          (String header) => DataColumn(
                            label: Text(header == 'null' ? '' : header, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                      source: _ExcelDataSource(excelData.sublist(1)),
                      rowsPerPage: 100,
                      showFirstLastButtons: true,
                      showEmptyRows: true,
                      dataRowMinHeight: 0,
                      dataRowMaxHeight: 40,
                      headingRowHeight: 40,
                      columnSpacing: 16,
                    ),
                  )
                : const Center(child: Text("Only XLSX files are supported")),
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
