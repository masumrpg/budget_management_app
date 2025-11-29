import 'dart:async';

import 'package:budget_management_app/models/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BudgetProvider extends ChangeNotifier {
  final Box<BudgetItem> _budgetBox = Hive.box<BudgetItem>('budgetBox');
  List<BudgetItem> _items = [];
  String _searchQuery = '';
  Timer? _debounce;

  List<BudgetItem> get items => _items;
  List<BudgetItem> get filteredItems {
    if (_searchQuery.isEmpty) {
      return _items;
    }
    return _items.where((item) {
      return item.itemName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.picName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  BudgetProvider() {
    loadBudgetItems();
  }

  void loadBudgetItems() {
    _items = _budgetBox.values.toList();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = query;
      notifyListeners();
    });
  }

  Future<void> addBudgetItem(BudgetItem item) async {
    await _budgetBox.put(item.id, item);
    loadBudgetItems();
  }

  Future<void> updateBudgetItem(BudgetItem item) async {
    await _budgetBox.put(item.id, item);
    loadBudgetItems();
  }

  Future<void> deleteBudgetItem(String id) async {
    await _budgetBox.delete(id);
    loadBudgetItems();
  }
}
