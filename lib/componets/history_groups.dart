import 'package:sumi/componets/history.dart';

Map<String, List<HistoryEntry>> groupByHour(List<HistoryEntry> entries) {
  final Map<String, List<HistoryEntry>> grouped = {};

  for (var entry in entries) {
    final String hourKey =
        "${entry.checkOutTime.hour}:00 - ${entry.checkOutTime.hour + 1}:00";

    if (!grouped.containsKey(hourKey)) {
      grouped[hourKey] = [];
    }
    grouped[hourKey]!.add(entry);
  }

  return grouped;
}

double calculateTotalRevenue(List<HistoryEntry> entries) {
  return entries.fold(0.0, (sum, entry) => sum + entry.price);
}
