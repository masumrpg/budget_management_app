import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class YearProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _currentYearKey = 'currentYear';

  int? _currentYear;
  
  int? get currentYear => _currentYear;

  YearProvider() {
    _loadCurrentYear();
  }

  Future<void> _loadCurrentYear() async {
    try {
      final box = await Hive.openBox(_boxName);
      _currentYear = box.get(_currentYearKey, defaultValue: DateTime.now().year);
      notifyListeners();
    } catch (e) {
      // Jika box belum diinisialisasi, buat dan set tahun saat ini
      await Hive.openBox(_boxName);
      final box = Hive.box(_boxName);
      _currentYear = box.get(_currentYearKey, defaultValue: DateTime.now().year);
      notifyListeners();
    }
  }

  Future<void> setCurrentYear(int year) async {
    _currentYear = year;
    
    try {
      final box = Hive.box(_boxName);
      await box.put(_currentYearKey, year);
      notifyListeners();
    } catch (e) {
      // Jika box belum dibuka, buka terlebih dahulu
      await Hive.openBox(_boxName);
      final box = Hive.box(_boxName);
      await box.put(_currentYearKey, year);
      notifyListeners();
    }
  }
  
  bool isYearSet() {
    return _currentYear != null;
  }
  
  void resetYear() {
    _currentYear = null;
    notifyListeners();
  }
}