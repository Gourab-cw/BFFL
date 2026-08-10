import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Datagrid3.dart';

bool isDateInRange(DateTime targetDate, DateTime startDate, DateTime endDate) {
  // Normalize dates to remove time components for accurate range checking
  final normalizedTargetDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
  final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
  final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);
  // Check if the target date is on or after the start date AND on or before the end date
  return (normalizedTargetDate.isAtSameMomentAs(normalizedStartDate) || normalizedTargetDate.isAfter(normalizedStartDate)) &&
      (normalizedTargetDate.isAtSameMomentAs(normalizedEndDate) || normalizedTargetDate.isBefore(normalizedEndDate));
}

void filterDateWidget({
  required DataGridHelperStore3 dataGridHelperStore,
  DateTimeRange? dateRange,
  required String dateFormat,
  required DataGridColumnModel3 column,
  required List<Map<String, dynamic>> dataSource,
}) {
  if (dateFormat.isNotEmpty && dateRange != null) {
    int filterIndex = dataGridHelperStore.filteredData.indexWhere((t) => t['key'] == column.dataField);
    List<String> filteredValue = dataSource
        .where((d) => d[column.dataField] != null && isDateInRange(DateFormat(dateFormat).parse(d[column.dataField]), dateRange.start, dateRange.end))
        .map<String>((m) => m[column.dataField])
        .toList();
    if (filterIndex != -1) {
      dataGridHelperStore.filteredData[filterIndex]["value"] = filteredValue;
    } else {
      dataGridHelperStore.filteredData.add({'key': column.dataField, 'value': filteredValue});
    }
  } else {
    int filterIndex = dataGridHelperStore.filteredData.indexWhere((t) => t['key'] == column.dataField);
    dataGridHelperStore.filteredData.value.removeAt(filterIndex);
  }
  // dataGridHelperStore.filteredData.refresh();
  // dataGridHelperStore.update();
}

DateTimeRange? getSelectedDateRange({
  required DataGridHelperStore3 dataGridHelperStore,
  DateTimeRange? dateRange,
  required String dateFormat,
  required DataGridColumnModel3 column,
  required List<Map<String, dynamic>> dataSource,
}) {
  int filterIndex = dataGridHelperStore.filteredData.indexWhere((t) => t['key'] == column.dataField);
  if (filterIndex != -1 && dataGridHelperStore.filteredData[filterIndex]['value'] is List) {
    List<DateTime> dates = dataGridHelperStore.filteredData[filterIndex]['value']
        .toSet()
        .toList()
        .map<DateTime>((m) => DateFormat(dateFormat).parse(m))
        .toList();
    dates.sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) {
      return null;
    }
    return DateTimeRange(start: dates.last, end: dates.first);
  }
  if (dataSource.isNotEmpty) {
    List<DateTime> dates = dataSource
        .where((w) => w[column.dataField] != null && w[column.dataField].toString().trim().isNotEmpty && w[column.dataField] != "0000-00-00 00:00:00")
        .map<DateTime>((m) => DateFormat(dateFormat).parse(m[column.dataField]))
        .toList();
    dates.sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) {
      return null;
    }
    return DateTimeRange(start: dates.last, end: dates.first);
  }
  return null;
}

DateTime getMaxDate({required String dateFormat, required DataGridColumnModel3 column, required List<Map<String, dynamic>> dataSource}) {
  List<String> dateList = dataSource.where((w) => w[column.dataField] != null).map<String>((m) => m[column.dataField]).toSet().toList();
  if (dateList.isEmpty || dateFormat.isEmpty) {
    return DateTime.now();
  }
  dateList.sort((a, b) => DateFormat(dateFormat).parse(b).compareTo(DateFormat(dateFormat).parse(a)));
  return DateFormat(dateFormat).parse(dateList.first);
}

DateTime getMinDate({required String dateFormat, required DataGridColumnModel3 column, required List<Map<String, dynamic>> dataSource}) {
  List<String> dateList = dataSource.where((w) => w[column.dataField] != null).map<String>((m) => m[column.dataField]).toSet().toList();
  if (dateList.isEmpty || dateFormat.isEmpty) {
    return DateTime.now();
  }
  dateList.sort((a, b) => DateFormat(dateFormat).parse(b).compareTo(DateFormat(dateFormat).parse(a)));
  return DateFormat(dateFormat).parse(dateList.last);
}
