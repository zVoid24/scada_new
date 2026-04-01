import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelStyles {
  static Style baseStyle(Workbook workbook, bool isDarkMode) {
    const String name = 'baseStyle';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = isDarkMode ? '#000000' : '#FFFFFF';
    style.fontColor = isDarkMode ? '#FFFFFF' : '#000000';
    return style;
  }

  static Style header(Workbook workbook, bool isDarkMode) {
    final String name = isDarkMode ? 'headerStyleDark' : 'headerStyleLight';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = '#0070C0'; // Professional Blue
    style.fontColor = '#FFFFFF';
    style.bold = true;
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = isDarkMode ? '#FFFFFF' : '#000000';
    return style;
  }

  static Style tableCell(Workbook workbook, bool isDarkMode) {
    final String name = isDarkMode ? 'tableCellStyleDark' : 'tableCellStyleLight';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = isDarkMode ? '#000000' : '#FFFFFF';
    style.fontColor = isDarkMode ? '#FFFFFF' : '#000000';
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = isDarkMode ? '#FFFFFF' : '#000000';
    return style;
  }

  static Style infoLabel(Workbook workbook, bool isDarkMode) {
    final String name = isDarkMode ? 'infoLabelStyleDark' : 'infoLabelStyleLight';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = isDarkMode ? '#000000' : '#FFFFFF';
    style.fontColor = isDarkMode ? '#FFFFFF' : '#000000';
    style.bold = true;
    style.vAlign = VAlignType.center;
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = isDarkMode ? '#FFFFFF' : '#000000';
    return style;
  }

  static Style infoValue(Workbook workbook, bool isDarkMode) {
    final String name = isDarkMode ? 'infoValueStyleDark' : 'infoValueStyleLight';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = isDarkMode ? '#000000' : '#FFFFFF';
    style.fontColor = isDarkMode ? '#FFFFFF' : '#000000';
    style.vAlign = VAlignType.center;
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = isDarkMode ? '#FFFFFF' : '#000000';
    return style;
  }

  static Style footer(Workbook workbook, bool isDarkMode) {
    final String name = isDarkMode ? 'footerStyleDark' : 'footerStyleLight';
    for (int i = 0; i < workbook.styles.count; i++) {
      if (workbook.styles[i]!.name == name) return workbook.styles[i]!;
    }
    final Style style = workbook.styles.add(name);
    style.backColor = isDarkMode ? '#000000' : '#FFFFFF';
    style.fontColor = isDarkMode ? '#FFFFFF' : '#000000';
    style.italic = true;
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    return style;
  }

  static void clear(Workbook workbook) {
    // Syncfusion doesn't have a clear styles, but we can manage it by not re-adding if they exist
    // However, usually we create a new workbook each time.
  }
}
