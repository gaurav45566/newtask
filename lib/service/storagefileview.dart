import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyMasterCard = "master_card";

  /// Save new card details
  static Future<void> saveDetails(Map<String, String> details) async {
    if (details.isEmpty) return; // ignore empty map

    final prefs = await SharedPreferences.getInstance();
    String? stored = prefs.getString(keyMasterCard);

    List<Map<String, String>> allData = [];

    if (stored != null && stored.isNotEmpty) {
      try {
        List<dynamic> decoded = jsonDecode(stored);
        allData = decoded.map((e) => Map<String, String>.from(e)).toList();
      } catch (e) {
        print("Error decoding stored data: $e");
        allData = [];
      }
    }

    allData.add(details); // append new card
    await prefs.setString(keyMasterCard, jsonEncode(allData));
    print("Saved details: $details");
  }

  /// Load all saved card details
  static Future<List<Map<String, String>>> loadDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? stored = prefs.getString(keyMasterCard);

    if (stored == null || stored.isEmpty) return [];

    try {
      List<dynamic> decoded = jsonDecode(stored);
      List<Map<String, String>> allData =
          decoded.map((e) => Map<String, String>.from(e)).toList();
      print("Loaded details: $allData");
      return allData;
    } catch (e) {
      print("Error decoding saved data: $e");
      return [];
    }
  }

  /// Clear all saved data (optional)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyMasterCard);
    print("All saved cards cleared.");
  }
}
