import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

/// A single row of chart data used for export.
class ChartRowData {
  const ChartRowData({
    required this.dateTime,
    required this.solar,
    required this.reb,
    required this.load,
    required this.generator,
    required this.ess,
  });

  final DateTime dateTime;
  final double solar;
  final double reb;
  final double load;
  final double generator;
  final double ess;
}

/// Provides static helpers to show a Cupertino action-sheet download dialog
/// and export chart data as Excel (.xlsx) or PDF.
class ChartDownloadService {
  ChartDownloadService._();

  // ──────────────────────────── Dialog ────────────────────────────

  static void showDownloadDialog({
    required BuildContext context,
    required String chartTitle,
    required List<ChartRowData> rows,
    required String dateFormat,
    required String filePrefix,
    String unit = 'kWh', // 'kW' for daily, 'kWh' for monthly/yearly
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(
          'Download $chartTitle',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        message: const Text('Select your preferred format'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadAsExcel(
                context: context,
                chartTitle: chartTitle,
                rows: rows,
                dateFormat: dateFormat,
                filePrefix: filePrefix,
                unit: unit,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF217346).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.table, color: Color(0xFF217346), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Excel (.xlsx)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF217346)),
                    ),
                    Text('Spreadsheet format', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadAsPDF(
                context: context,
                chartTitle: chartTitle,
                rows: rows,
                dateFormat: dateFormat,
                filePrefix: filePrefix,
                unit: unit,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.doc_text_fill, color: Color(0xFFE53935), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PDF (.pdf)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE53935)),
                    ),
                    Text('Document format', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  // ──────────────────────────── Excel ────────────────────────────

  static Future<void> _downloadAsExcel({
    required BuildContext context,
    required String chartTitle,
    required List<ChartRowData> rows,
    required String dateFormat,
    required String filePrefix,
    String unit = 'kWh',
  }) async {
    try {
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];
      sheet.name = chartTitle;

      final List<String> headers = [
        'Date / Time',
        'Solar ($unit)',
        'REB ($unit)',
        'Load ($unit)',
        'Generator ($unit)',
        'ESS ($unit)',
      ];

      // Header row
      for (int i = 0; i < headers.length; i++) {
        final xlsio.Range cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle.bold = true;
        cell.cellStyle.backColor = '#4472C4';
        cell.cellStyle.fontColor = '#FFFFFF';
        cell.cellStyle.hAlign = xlsio.HAlignType.center;
        cell.cellStyle.vAlign = xlsio.VAlignType.center;
        cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
        cell.cellStyle.borders.all.color = '#000000';
      }

      // Data rows
      for (int r = 0; r < rows.length; r++) {
        final ChartRowData d = rows[r];
        final int row = r + 2;

        // Date cell
        final dateCell = sheet.getRangeByIndex(row, 1);
        dateCell.setText(DateFormat(dateFormat).format(d.dateTime));
        dateCell.cellStyle.hAlign = xlsio.HAlignType.center;
        dateCell.cellStyle.vAlign = xlsio.VAlignType.center;
        dateCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
        dateCell.cellStyle.borders.all.color = '#000000';

        // Numeric cells
        final List<double> values = [d.solar, d.reb, d.load, d.generator, d.ess];
        for (int c = 0; c < values.length; c++) {
          final numCell = sheet.getRangeByIndex(row, c + 2);
          numCell.setNumber(values[c]);
          numCell.cellStyle.numberFormat = '#,##0.00';
          numCell.cellStyle.hAlign = xlsio.HAlignType.center;
          numCell.cellStyle.vAlign = xlsio.VAlignType.center;
          numCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
          numCell.cellStyle.borders.all.color = '#000000';
        }
      }

      // Auto-fit columns
      for (int i = 1; i <= headers.length; i++) {
        sheet.autoFitColumn(i);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final ts = DateFormat('dd-MMM-yyyy_HH-mm-ss').format(DateTime.now());
      final fileName = '${filePrefix}_${ts}.xlsx';
      final filePath = '${directory.path}/$fileName';
      await File(filePath).writeAsBytes(bytes);

      if (context.mounted) _showSuccessDialog(context, filePath, fileName);
    } catch (e) {
      debugPrint('Excel export error: $e');
      if (context.mounted) _showErrorDialog(context, 'Error creating Excel file:\n$e');
    }
  }

  // ──────────────────────────── PDF ────────────────────────────

  static Future<void> _downloadAsPDF({
    required BuildContext context,
    required String chartTitle,
    required List<ChartRowData> rows,
    required String dateFormat,
    required String filePrefix,
    String unit = 'kWh',
  }) async {
    try {
      const int rowsPerPage = 25;
      final PdfDocument document = PdfDocument();

      final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
      final subFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
      final headerFont = PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
      final dataFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

      for (int i = 0; i < rows.length; i += rowsPerPage) {
        final chunk = rows.skip(i).take(rowsPerPage).toList();
        final PdfPage page = document.pages.add();
        final PdfGraphics g = page.graphics;
        final double pageWidth = page.getClientSize().width;

        // Title
        g.drawString(chartTitle, titleFont,
            brush: PdfSolidBrush(PdfColor(33, 33, 33)),
            bounds: Rect.fromLTWH(20, 20, pageWidth - 40, 30));

        // Sub info
        g.drawString(
          'Generated: ${DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now())}   |   '
          'Page ${(i ~/ rowsPerPage) + 1} of ${(rows.length / rowsPerPage).ceil()}',
          subFont,
          brush: PdfSolidBrush(PdfColor(100, 100, 100)),
          bounds: Rect.fromLTWH(20, 50, pageWidth - 40, 20),
        );

        // Table
        final PdfGrid grid = PdfGrid();
        grid.columns.add(count: 6);
        grid.columns[0].width = 120;

        final PdfGridRow headerRow = grid.headers.add(1)[0];
        final List<String> cols = ['Date/Time', 'Solar', 'REB', 'Load', 'Generator', 'ESS'];
        for (int j = 0; j < cols.length; j++) {
          headerRow.cells[j].value = j == 0 ? cols[j] : '${cols[j]} ($unit)';
          headerRow.cells[j].style = PdfGridCellStyle(
            backgroundBrush: PdfSolidBrush(PdfColor(68, 114, 196)),
            textBrush: PdfBrushes.white,
            font: headerFont,
            format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle,
            ),
          );
        }

        for (int r = 0; r < chunk.length; r++) {
          final d = chunk[r];
          final PdfGridRow row = grid.rows.add();
          row.cells[0].value = DateFormat(dateFormat).format(d.dateTime);
          row.cells[1].value = d.solar.toStringAsFixed(2);
          row.cells[2].value = d.reb.toStringAsFixed(2);
          row.cells[3].value = d.load.toStringAsFixed(2);
          row.cells[4].value = d.generator.toStringAsFixed(2);
          row.cells[5].value = d.ess.toStringAsFixed(2);

          final PdfColor bg = r.isEven ? PdfColor(245, 245, 245) : PdfColor(255, 255, 255);
          for (int j = 0; j < 6; j++) {
            row.cells[j].style = PdfGridCellStyle(
              backgroundBrush: PdfSolidBrush(bg),
              font: dataFont,
              format: PdfStringFormat(
                alignment: j == 0 ? PdfTextAlignment.left : PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.middle,
              ),
            );
          }
        }

        grid.draw(
          page: page,
          bounds: Rect.fromLTWH(20, 75, pageWidth - 40, page.getClientSize().height - 95),
        );
      }

      final List<int> bytes = document.saveSync();
      document.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final ts = DateFormat('dd-MMM-yyyy_HH-mm-ss').format(DateTime.now());
      final fileName = '${filePrefix}_${ts}.pdf';
      final filePath = '${directory.path}/$fileName';
      await File(filePath).writeAsBytes(bytes);

      if (context.mounted) _showSuccessDialog(context, filePath, fileName);
    } catch (e) {
      debugPrint('PDF export error: $e');
      if (context.mounted) _showErrorDialog(context, 'Error creating PDF file:\n$e');
    }
  }

  // ──────────────────────────── Success / Error Dialogs ────────────────────────────

  static void _showSuccessDialog(BuildContext context, String filePath, String fileName) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF4CAF50), size: 24),
            SizedBox(width: 8),
            Text('Download Complete'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(CupertinoIcons.doc_checkmark, color: Color(0xFF4CAF50), size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              fileName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Saved to Documents', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              OpenFile.open(filePath);
            },
            child: const Text('Open File'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.xmark_circle_fill, color: Color(0xFFE53935), size: 24),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(message),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
