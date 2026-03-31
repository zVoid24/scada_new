// // ==================== Download Dialog ====================
// Future<void> _showDownloadDialog() async {
//   showCupertinoModalPopup(
//     context: context,
//     builder: (BuildContext context) => CupertinoActionSheet(
//       title: const Text('Download AC Power Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//       message: const Text('Select your preferred format'),
//       actions: <CupertinoActionSheetAction>[
//         CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.pop(context);
//             _downloadAsExcel();
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF217346).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(CupertinoIcons.table, color: Color(0xFF217346), size: 20),
//               ),
//               const SizedBox(width: 12),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Excel (.xlsx)',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF217346)),
//                   ),
//                   Text('Spreadsheet format', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.pop(context);
//             _downloadAsPDF();
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE53935).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(CupertinoIcons.doc_text_fill, color: Color(0xFFE53935), size: 20),
//               ),
//               const SizedBox(width: 12),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'PDF (.pdf)',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE53935)),
//                   ),
//                   Text('Document format', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//       cancelButton: CupertinoActionSheetAction(
//         isDestructiveAction: true,
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: const Text('Cancel'),
//       ),
//     ),
//   );
// }

// // ==================== Success Dialog ====================
// void _showSuccessDialog(String filePath, String fileName) {
//   showCupertinoDialog(
//     context: context,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF4CAF50), size: 24),
//           SizedBox(width: 8),
//           Text('Download Complete'),
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4CAF50).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(CupertinoIcons.doc_checkmark, color: Color(0xFF4CAF50), size: 40),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             fileName,
//             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           Text('Saved to Documents', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         ],
//       ),
//       actions: <CupertinoDialogAction>[
//         CupertinoDialogAction(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Done'),
//         ),
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           onPressed: () {
//             Navigator.pop(context);
//             _openFile(filePath);
//           },
//           child: const Text('Open File'),
//         ),
//       ],
//     ),
//   );
// }

// // ==================== Error Dialog ====================
// void _showErrorDialog(String message) {
//   showCupertinoDialog(
//     context: context,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(CupertinoIcons.xmark_circle_fill, color: Color(0xFFE53935), size: 24),
//           SizedBox(width: 8),
//           Text('Error'),
//         ],
//       ),
//       content: Padding(padding: const EdgeInsets.only(top: 12), child: Text(message)),
//       actions: <CupertinoDialogAction>[
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }

// // ==================== Open File ====================
// Future<void> _openFile(String filePath) async {
//   try {
//     final result = await OpenFile.open(filePath);
//     if (result.type != ResultType.done) {
//       _showErrorDialog('Unable to open file: ${result.message}');
//     }
//   } catch (e) {
//     _showErrorDialog('Error opening file: $e');
//   }
// }

// // ==================== Download as Excel ====================
// Future<void> _downloadAsExcel() async {
//   setState(() {
//     isDownloading = true;
//   });

//   try {
//     if (chartData.isEmpty) {
//       _showErrorDialog('No data available to download');
//       setState(() {
//         isDownloading = false;
//       });
//       return;
//     }

//     // Filter data: display range 6 AM to 7 PM (after subtracting 6 hours)
//     // This means actual data time should be 12 PM to 1 AM next day
//     final now = DateTime.now();
//     final displayStartTime = DateTime(now.year, now.month, now.day, 6, 0, 0);
//     final displayEndTime = DateTime(now.year, now.month, now.day, 19, 0, 0);

//     final filteredData = chartData.where((data) {
//       // Subtract 6 hours to get display time
//       final adjustedTime = data.time.subtract(const Duration(hours: 6));
//       return adjustedTime.isAfter(displayStartTime.subtract(const Duration(seconds: 1))) &&
//           adjustedTime.isBefore(displayEndTime.add(const Duration(seconds: 1)));
//     }).toList();

//     if (filteredData.isEmpty) {
//       _showErrorDialog('No data available in the 6 AM - 7 PM range');
//       setState(() {
//         isDownloading = false;
//       });
//       return;
//     }

//     final xlsio.Workbook workbook = xlsio.Workbook();
//     final xlsio.Worksheet sheet = workbook.worksheets[0];
//     sheet.name = 'AC Power Data';

//     // Headers
//     final List<String> headers = ['Date/Time', 'AC Power (kW)'];

//     for (int i = 0; i < headers.length; i++) {
//       final xlsio.Range cell = sheet.getRangeByIndex(1, i + 1);
//       cell.setText(headers[i]);
//       cell.cellStyle.bold = true;
//       cell.cellStyle.backColor = '#4472C4';
//       cell.cellStyle.fontColor = '#FFFFFF';
//       cell.cellStyle.hAlign = xlsio.HAlignType.center;
//       cell.cellStyle.vAlign = xlsio.VAlignType.center;
//       cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
//       cell.cellStyle.borders.all.color = '#000000';
//     }

//     // Data rows - with 6-hour subtraction (same as graph)
//     for (int rowIndex = 0; rowIndex < filteredData.length; rowIndex++) {
//       var data = filteredData[rowIndex];

//       // Subtract 6 hours to match graph display
//       final adjustedTime = data.time.subtract(const Duration(hours: 6));

//       final timeCell = sheet.getRangeByIndex(rowIndex + 2, 1);
//       timeCell.setText(DateFormat('dd-MMM-yyyy hh:mm a').format(adjustedTime));
//       timeCell.cellStyle.hAlign = xlsio.HAlignType.center;
//       timeCell.cellStyle.vAlign = xlsio.VAlignType.center;
//       timeCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
//       timeCell.cellStyle.borders.all.color = '#000000';

//       final valueCell = sheet.getRangeByIndex(rowIndex + 2, 2);
//       valueCell.setNumber(data.totalAcPower);
//       valueCell.cellStyle.hAlign = xlsio.HAlignType.center;
//       valueCell.cellStyle.vAlign = xlsio.VAlignType.center;
//       valueCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
//       valueCell.cellStyle.borders.all.color = '#000000';
//     }

//     // Auto-fit columns
//     for (int i = 1; i <= headers.length; i++) {
//       sheet.autoFitColumn(i);
//     }

//     final List<int> bytes = workbook.saveAsStream();
//     workbook.dispose();

//     final directory = await getApplicationDocumentsDirectory();
//     final now2 = DateTime.now();
//     final fileName = 'AcPowerData_${DateFormat('dd-MMM-yyyy_hh-mm-ssa').format(now2)}.xlsx';
//     final filePath = '${directory.path}/$fileName';
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);

//     setState(() {
//       isDownloading = false;
//     });

//     _showSuccessDialog(filePath, fileName);
//   } catch (e) {
//     setState(() {
//       isDownloading = false;
//     });
//     _showErrorDialog('Error downloading Excel: $e');
//     debugPrint('Error downloading Excel: $e');
//   }
// }

// // ==================== Download as PDF ====================
// Future<void> _downloadAsPDF() async {
//   setState(() {
//     isDownloading = true;
//   });

//   try {
//     if (chartData.isEmpty) {
//       _showErrorDialog('No data available to download');
//       setState(() {
//         isDownloading = false;
//       });
//       return;
//     }

//     // Filter data: display range 6 AM to 7 PM (after subtracting 6 hours)
//     // This means actual data time should be 12 PM to 1 AM next day
//     final now = DateTime.now();
//     final displayStartTime = DateTime(now.year, now.month, now.day, 6, 0, 0);
//     final displayEndTime = DateTime(now.year, now.month, now.day, 19, 0, 0);

//     final filteredData = chartData.where((data) {
//       // Subtract 6 hours to get display time
//       final adjustedTime = data.time.subtract(const Duration(hours: 6));
//       return adjustedTime.isAfter(displayStartTime.subtract(const Duration(seconds: 1))) &&
//           adjustedTime.isBefore(displayEndTime.add(const Duration(seconds: 1)));
//     }).toList();

//     if (filteredData.isEmpty) {
//       _showErrorDialog('No data available in the 6 AM - 7 PM range');
//       setState(() {
//         isDownloading = false;
//       });
//       return;
//     }

//     final PdfDocument document = PdfDocument();

//     const int rowsPerPage = 30;

//     for (int i = 0; i < filteredData.length; i += rowsPerPage) {
//       final chunk = filteredData.skip(i).take(rowsPerPage).toList();
//       final PdfPage page = document.pages.add();
//       final PdfGraphics graphics = page.graphics;

//       // Title
//       graphics.drawString(
//         'AC Power Report',
//         PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
//         bounds: const Rect.fromLTWH(20, 20, 0, 0),
//       );

//       // Date range
//       graphics.drawString(
//         'Data Range: 6:00 AM - 7:00 PM',
//         PdfStandardFont(PdfFontFamily.helvetica, 10),
//         bounds: const Rect.fromLTWH(20, 45, 0, 0),
//       );

//       // Generated date
//       graphics.drawString(
//         'Generated: ${DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.now())}',
//         PdfStandardFont(PdfFontFamily.helvetica, 10),
//         bounds: const Rect.fromLTWH(20, 60, 0, 0),
//       );

//       // Page number
//       graphics.drawString(
//         'Page ${(i ~/ rowsPerPage) + 1} of ${(filteredData.length / rowsPerPage).ceil()}',
//         PdfStandardFont(PdfFontFamily.helvetica, 10),
//         bounds: const Rect.fromLTWH(20, 75, 0, 0),
//       );

//       // Create table
//       final PdfGrid grid = PdfGrid();
//       grid.columns.add(count: 2);

//       // Headers
//       final PdfGridRow headerRow = grid.headers.add(1)[0];
//       headerRow.cells[0].value = 'Date/Time';
//       headerRow.cells[1].value = 'AC Power (kW)';

//       for (int j = 0; j < 2; j++) {
//         headerRow.cells[j].style = PdfGridCellStyle(
//           backgroundBrush: PdfSolidBrush(PdfColor(68, 114, 196)),
//           textBrush: PdfBrushes.white,
//           font: PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
//           format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle),
//         );
//       }

//       // Data rows - with 6-hour subtraction (same as graph)
//       for (var data in chunk) {
//         final PdfGridRow row = grid.rows.add();

//         // Subtract 6 hours to match graph display
//         final adjustedTime = data.time.subtract(const Duration(hours: 6));

//         row.cells[0].value = DateFormat('dd-MMM-yyyy hh:mm a').format(adjustedTime);
//         row.cells[1].value = data.totalAcPower.toStringAsFixed(2);

//         for (int j = 0; j < 2; j++) {
//           row.cells[j].style = PdfGridCellStyle(
//             font: PdfStandardFont(PdfFontFamily.helvetica, 8),
//             format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle),
//           );
//         }
//       }

//       grid.draw(
//         page: page,
//         bounds: Rect.fromLTWH(20, 95, page.getClientSize().width - 40, page.getClientSize().height - 115),
//       );
//     }

//     final List<int> bytes = document.saveSync();
//     document.dispose();

//     final directory = await getApplicationDocumentsDirectory();
//     final now2 = DateTime.now();
//     final fileName = 'AcPowerData_${DateFormat('dd-MMM-yyyy_hh-mm-ssa').format(now2)}.pdf';
//     final filePath = '${directory.path}/$fileName';
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);

//     setState(() {
//       isDownloading = false;
//     });

//     _showSuccessDialog(filePath, fileName);
//   } catch (e) {
//     setState(() {
//       isDownloading = false;
//     });
//     _showErrorDialog('Error downloading PDF: $e');
//     debugPrint('Error downloading PDF: $e');
//   }
// }
