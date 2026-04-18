import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveCacheHelper {
  static const String productsBoxName = 'products_box';
  static const String ordersBoxName = 'orders_box';
  static const String profileBoxName = 'profile_box';
  static const String settingsBoxName = 'settings_box';
  static const String analyticsBoxName = 'analytics_box';

  static Future<Box> _openSafeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box(boxName);
      }
      return await Hive.openBox(boxName);
    } catch (e) {
      debugPrint('Hive Error opening $boxName: $e');
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox(boxName);
    }
  }

  static Future<void> saveData<T>({
    required String boxName,
    required dynamic key,
    required T value,
  }) async {
    try {
      final box = await _openSafeBox(boxName);
      await box.put(key, value);
    } catch (e) {
      debugPrint('Error saving to Hive: $e');
      rethrow;
    }
  }

  static Future<T?> getData<T>({
    required String boxName,
    required dynamic key,
  }) async {
    try {
      final box = await _openSafeBox(boxName);
      final data = box.get(key);
      if (data is T) return data;

      if (data is List && T.toString().contains('List')) {
        return data as T;
      }
      return null;
    } catch (e) {
      debugPrint('Error reading from Hive: $e');
      return null;
    }
  }

  static Future<void> clearBox(String boxName) async {
    final box = await _openSafeBox(boxName);
    await box.clear();
  }
}
