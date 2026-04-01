import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scada_new/services/excel_styles.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

/// A single row of chart data used for export.
class ChartRowData {
  const ChartRowData({
    required this.dateTime,
    required this.solar,
    required this.grid,
    required this.load,
    required this.generator,
    required this.ess,
  });

  final DateTime dateTime;
  final double solar;
  final double grid;
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
    Future<Uint8List?> Function()? onCaptureChart,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text('Download $chartTitle', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
            onPressed: () async {
              Navigator.pop(ctx);
              final Uint8List? image = onCaptureChart != null ? await onCaptureChart() : null;
              // Check if context is still valid after async gap
              if (!context.mounted) return;
              _downloadAsPDF(
                context: context,
                chartTitle: chartTitle,
                rows: rows,
                dateFormat: dateFormat,
                filePrefix: filePrefix,
                unit: unit,
                chartImage: image,
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
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];
      sheet.name = chartTitle;

      // 0. Global Background
      final xlsio.Style baseStyle = ExcelStyles.baseStyle(workbook, isDarkMode);
      sheet.getRangeByName('A1:Z500').cellStyle = baseStyle;

      // 1. Column Widths
      sheet.getRangeByIndex(1, 1).columnWidth = 22.0; // Date/Time
      for (int i = 2; i <= 6; i++) {
        sheet.getRangeByIndex(1, i).columnWidth = 18.0; // Data columns
      }

      // 2. Pre-cache Styles
      final xlsio.Style headerStyle = ExcelStyles.header(workbook, isDarkMode);
      final xlsio.Style tableStyle = ExcelStyles.tableCell(workbook, isDarkMode);
      final xlsio.Style infoLabelStyle = ExcelStyles.infoLabel(workbook, isDarkMode);
      final xlsio.Style infoValueStyle = ExcelStyles.infoValue(workbook, isDarkMode);

      // 3. Add Logo (with graceful failure)
      try {
        sheet.getRangeByName('A1:A3').merge();
        for (int i = 1; i <= 4; i++) {
          sheet.getRangeByIndex(i, 1).rowHeight = 22;
        }
        final ByteData data = await rootBundle.load('assets/logo2.jpg');
        final Uint8List bytes = data.buffer.asUint8List();
        final picture = sheet.pictures.addStream(1, 1, bytes);
        picture.height = 90;
        picture.width = 130;
        picture.lastColumn = 2;
        picture.lastRow = 4;
      } catch (e) {
        debugPrint('Logo loading error: $e');
        // If logo fails, we just leave the space or put a placeholder
        sheet.getRangeByName('A1:A3').merge();
        final logoCell = sheet.getRangeByIndex(1, 1);
        logoCell.setText('SCUBE GROUP');
        logoCell.cellStyle = infoLabelStyle;
        logoCell.cellStyle.hAlign = xlsio.HAlignType.center;
      }

      // 4. Info Section (Rows 1-4, Columns B-E)
      void addInfoRow(int row, String label, String value) {
        sheet.getRangeByIndex(row, 2).setText(label);
        sheet.getRangeByIndex(row, 2).cellStyle = infoLabelStyle;
        sheet.getRangeByIndex(row, 3).cellStyle = infoLabelStyle;
        sheet.getRangeByName('B$row:C$row').merge();

        sheet.getRangeByIndex(row, 4).setText(value);
        sheet.getRangeByIndex(row, 4).cellStyle = infoValueStyle;
        sheet.getRangeByIndex(row, 5).cellStyle = infoValueStyle;
        sheet.getRangeByIndex(row, 6).cellStyle = infoValueStyle;
        sheet.getRangeByName('D$row:F$row').merge();
      }

      addInfoRow(1, 'Project Name', 'SCADA Monitoring System');
      addInfoRow(2, 'Date & Time', DateFormat('dd MMMM yyyy @ hh:mm a').format(DateTime.now()));
      addInfoRow(3, 'User Name', 'Sabbir'); // Default user name as per screenshot
      // Row 4 can be a spacer or extra info
      sheet.getRangeByName('B4:F4').merge();
      sheet.getRangeByIndex(4, 2).cellStyle = infoValueStyle;

      // 5. Table Headers (Row 5)
      final List<String> headers = [
        'Date & Time (UTC)',
        'Solar ($unit)',
        'Grid ($unit)',
        'Load ($unit)',
        'Generator ($unit)',
        'ESS ($unit)',
      ];

      for (int i = 0; i < headers.length; i++) {
        final xlsio.Range cell = sheet.getRangeByIndex(5, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      // 6. Data Rows (Row 6 onwards)
      for (int r = 0; r < rows.length; r++) {
        final ChartRowData d = rows[r];
        final int row = r + 6;

        // Date cell
        final dateCell = sheet.getRangeByIndex(row, 1);
        dateCell.setText(DateFormat(dateFormat).format(d.dateTime));
        dateCell.cellStyle = tableStyle;

        // Numeric cells
        final List<double> values = [d.solar, d.grid, d.load, d.generator, d.ess];
        for (int c = 0; c < values.length; c++) {
          final numCell = sheet.getRangeByIndex(row, c + 2);
          numCell.setNumber(values[c]);
          numCell.cellStyle = tableStyle;
          numCell.cellStyle.numberFormat = '#,##0.00';
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final ts = DateFormat('dd-MMM-yyyy_HH-mm-ss').format(DateTime.now());
      final fileName = '${filePrefix}_$ts.xlsx';
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
    Uint8List? chartImage,
  }) async {
    try {
      final PdfDocument document = PdfDocument();
      document.pageSettings.margins.left = 0;
      document.pageSettings.margins.right = 0;
      document.pageSettings.margins.top = 30;
      document.pageSettings.margins.bottom = 0;
      document.pageSettings.orientation = PdfPageOrientation.portrait;

      final double pageWidth = document.pageSettings.width;
      const double marginX = 30.0;
      final double contentWidth = pageWidth - (marginX * 2);

      // =====================
      // 0. FOOTER (Persistent on all pages)
      // =====================
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, document.pageSettings.width, 25),
      );
      final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

      // Blue Background
      footer.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(68, 114, 196)),
        bounds: Rect.fromLTWH(0, 0, document.pageSettings.width, 25),
      );

      // Attribution Text (Center)
      footer.graphics.drawString(
        'Data Source: SolScada | Powered by: Scube Technologies Limited',
        footerFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(0, 0, pageWidth, 25),
        format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle),
      );

      // Page Number (Right)
      final PdfPageNumberField pageNumber = PdfPageNumberField(font: footerFont, brush: PdfBrushes.white);
      final PdfPageCountField pageCount = PdfPageCountField(font: footerFont, brush: PdfBrushes.white);
      final PdfCompositeField compositeField = PdfCompositeField(
        font: footerFont,
        brush: PdfBrushes.white,
        text: 'Page {0} of {1}',
        fields: <PdfAutomaticField>[pageNumber, pageCount],
      );
      compositeField.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.right,
        lineAlignment: PdfVerticalAlignment.middle,
      );
      compositeField.bounds = Rect.fromLTWH(0, 0, pageWidth - marginX, 25);
      compositeField.draw(footer.graphics);

      // Apply template to bottom of each page
      document.template.bottom = footer;

      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
      final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
      final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

      final PdfPage page = document.pages.add();
      final PdfGraphics g = page.graphics;
      double cursorY = 0;

      // =====================
      // 1. HEADER (Logo + Project Info)
      // =====================
      final PdfGrid headerGrid = PdfGrid();
      headerGrid.columns.add(count: 3);
      headerGrid.columns[0].width = 160; // Logo area
      headerGrid.columns[1].width = 120; // Label area
      headerGrid.columns[2].width = contentWidth - 280; // Value area

      void addHeaderInfo(String k, String v) {
        final r = headerGrid.rows.add();
        r.cells[1].value = k;
        r.cells[2].value = v;
        r.cells[1].style.font = headerFont;
        r.cells[1].style.backgroundBrush = PdfSolidBrush(PdfColor(240, 240, 240));
        r.cells[2].style.font = normalFont;
      }

      addHeaderInfo('Project Name', 'Alhaz Karim Textile LTD');
      addHeaderInfo(
        'Date Range',
        '${DateFormat('yyyy-MM-dd').format(rows.first.dateTime)} to ${DateFormat('yyyy-MM-dd').format(rows.last.dateTime)}',
      );
      addHeaderInfo('Printed', DateFormat('dd MMMM yyyy at hh:mm a').format(DateTime.now()));
      addHeaderInfo('User Name', 'SabbiR');

      headerGrid.style.cellPadding = PdfPaddings(left: 10, top: 8, bottom: 8, right: 5);

      // Merge all rows of the first column (Logo Area) to have a single border around it
      final PdfGridCell logoCell = headerGrid.rows[0].cells[0];
      logoCell.rowSpan = 4;
      logoCell.style.borders.all = PdfPen(PdfColor(0, 0, 0), width: 0.5);

      final PdfLayoutResult headerResult = headerGrid.draw(
        page: page,
        bounds: Rect.fromLTWH(marginX, 0, contentWidth, 0),
      )!;

      // Logo
      try {
        final ByteData logoData = await rootBundle.load('assets/logo3.jpg');
        final PdfBitmap logoImage = PdfBitmap(logoData.buffer.asUint8List());
        final double logoH = headerResult.bounds.height - 20;
        const double logoW = 130;
        g.drawImage(logoImage, Rect.fromLTWH(marginX + 10, (headerResult.bounds.height - logoH) / 2, logoW, logoH));
      } catch (e) {
        debugPrint('PDF Logo error: $e');
      }

      cursorY = headerResult.bounds.bottom + 20;

      // =====================
      // 2. CHART SECTION
      // =====================
      g.drawString(
        chartTitle,
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 199, 229)),
        bounds: Rect.fromLTWH(marginX, cursorY, contentWidth, 25),
      );
      cursorY += 30;

      if (chartImage != null) {
        final PdfBitmap chartBitmap = PdfBitmap(chartImage);
        g.drawImage(chartBitmap, Rect.fromLTWH(marginX, cursorY, contentWidth, 220));
        cursorY += 230;
      } else {
        cursorY += 10;
      }

      // =====================
      // 3. DATA TABLE
      // =====================
      g.drawString(
        'Data Table',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 199, 229)),
        bounds: Rect.fromLTWH(marginX, cursorY, contentWidth, 25),
      );
      cursorY += 30;

      final PdfGrid table = PdfGrid();
      table.columns.add(count: 6);
      table.columns[0].width = 120;

      final PdfGridRow head = table.headers.add(1)[0];
      final List<String> labels = ['Date & Time (UTC)', 'Solar', 'Grid', 'Load', 'Generator', 'ESS'];
      for (int i = 0; i < labels.length; i++) {
        head.cells[i].value = i == 0 ? labels[i] : '${labels[i]} ($unit)';
        head.cells[i].style = PdfGridCellStyle(
          backgroundBrush: PdfSolidBrush(PdfColor(68, 114, 196)),
          textBrush: PdfBrushes.white,
          font: headerFont,
          format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle),
        );
      }

      for (int r = 0; r < rows.length; r++) {
        final d = rows[r];
        final PdfGridRow row = table.rows.add();
        row.cells[0].value = DateFormat(dateFormat).format(d.dateTime);
        row.cells[1].value = d.solar.toStringAsFixed(2);
        row.cells[2].value = d.grid.toStringAsFixed(2);
        row.cells[3].value = d.load.toStringAsFixed(2);
        row.cells[4].value = d.generator.toStringAsFixed(2);
        row.cells[5].value = d.ess.toStringAsFixed(2);

        final PdfBrush bgBrush = r.isEven ? PdfSolidBrush(PdfColor(245, 250, 255)) : PdfBrushes.white;
        for (int c = 0; c < 6; c++) {
          row.cells[c].style = PdfGridCellStyle(
            backgroundBrush: bgBrush,
            font: normalFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle),
          );
        }
      }

      table.style = PdfGridStyle(font: normalFont, cellPadding: PdfPaddings(left: 6, top: 6, bottom: 6, right: 6));
      table.draw(page: page, bounds: Rect.fromLTWH(marginX, cursorY, contentWidth, 0));

      final List<int> bytes = document.saveSync();
      document.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final ts = DateFormat('dd-MMM-yyyy_HH-mm-ss').format(DateTime.now());
      final fileName = '${filePrefix}_$ts.pdf';
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
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
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
        content: Padding(padding: const EdgeInsets.only(top: 12), child: Text(message)),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}
