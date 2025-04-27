import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart'; // <-- Import modelnya

class HistoryProvider {
  static const String _key = 'history_list';

  static Future<void> saveHistory({
    required String kategori,
    required String penyelesaian,
    required String imagePath,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> currentList = prefs.getStringList(_key) ?? [];

    HistoryItem newItem = HistoryItem(
      kategori: kategori,
      penyelesaian: penyelesaian,
      imagePath: imagePath,
      waktu: DateTime.now(),
    );

    currentList.add(jsonEncode(newItem.toJson()));

    await prefs.setStringList(_key, currentList);
    print('Data disimpan: ${newItem.toJson()}');
  }

  static Future<List<HistoryItem>> getHistories({
    bool newestFirst = true,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> currentList = prefs.getStringList(_key) ?? [];

      List<HistoryItem> historyItems =
          currentList
              .map((item) => HistoryItem.fromJson(jsonDecode(item)))
              .toList();

      if (newestFirst) {
        historyItems.sort((a, b) => b.waktu.compareTo(a.waktu));
      }

      return historyItems;
    } catch (e) {
      print('Error loading histories: $e');
      return [];
    }
  }

  static Future<void> deleteHistoryAt(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      await prefs.setStringList(_key, currentList);
    }
  }

  static Future<void> clearHistories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
