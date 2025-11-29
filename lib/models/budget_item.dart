import 'package:hive/hive.dart';

part 'budget_item.g.dart';

@HiveType(typeId: 0)
class BudgetItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String itemName;

  @HiveField(2)
  String picName;

  @HiveField(3)
  double yearlyBudget;

  @HiveField(4)
  int frequency;

  @HiveField(5)
  List<int> activeMonths;

  @HiveField(6)
  Map<int, double> monthlyWithdrawals;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? lastUpdated;

  @HiveField(9)
  String? notes;

  BudgetItem({
    required this.id,
    required this.itemName,
    required this.picName,
    required this.yearlyBudget,
    required this.frequency,
    required this.activeMonths,
    this.monthlyWithdrawals = const {},
    DateTime? createdAt,
    this.lastUpdated,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  // Computed properties
  double get totalUsed => monthlyWithdrawals.values
    .fold(0.0, (sum, amount) => sum + amount);

  double get remaining => yearlyBudget - totalUsed;

  double get usagePercentage =>
    yearlyBudget > 0 ? (totalUsed / yearlyBudget) * 100 : 0;

  bool get isOverBudget => remaining < 0;

  List<int> get emptyActiveMonths => activeMonths
    .where((month) => (monthlyWithdrawals[month] ?? 0) == 0)
    .toList();

  // Validation
  bool validate() {
    return itemName.isNotEmpty &&
           picName.isNotEmpty &&
           yearlyBudget > 0 &&
           frequency > 0 &&
           activeMonths.length == frequency;
  }
}
