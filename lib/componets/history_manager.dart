import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumi/componets/history.dart';

class HistoryManager {
  static const String historyKey = 'history';

  static Future<void> addHistoryEntry(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(historyKey) ?? [];

    // Check for duplicate Receipt ID
    for (String item in history) {
      final existingEntry = HistoryEntry.fromJson(jsonDecode(item));
      if (existingEntry.receiptId == entry.receiptId) {
        throw Exception("Duplicate Receipt ID: ${entry.receiptId}");
      }
    }

    history.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(historyKey, history);
  }

  static Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(historyKey) ?? [];
    return history
        .map((entry) => HistoryEntry.fromJson(jsonDecode(entry)))
        .toList();
  }
}
