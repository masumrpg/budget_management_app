import 'dart:io';
import 'package:budget_management_app/models/budget_item.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static Future<String?> exportToExcel(List<BudgetItem> items) async {
    final excel = Excel.createExcel();
    final sheet = excel['Budget Report'];

    final headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue,
      fontColorHex: ExcelColor.white,
      bold: true,
    );

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final headers = ['Item Name', 'PIC', 'Yearly Budget', ...months, 'Total Used', 'Remaining'];

    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = headerStyle;
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(item.itemName);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(item.picName);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = DoubleCellValue(item.yearlyBudget);

      for (var j = 0; j < months.length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j + 3, rowIndex: rowIndex)).value = DoubleCellValue(item.monthlyWithdrawals[j] ?? 0);
      }

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex)).value = DoubleCellValue(item.totalUsed);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: rowIndex)).value = DoubleCellValue(item.remaining);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/budget_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      return path;
    }
    return null;
  }
}

