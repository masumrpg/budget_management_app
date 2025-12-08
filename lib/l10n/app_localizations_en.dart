// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Budget Management';

  @override
  String get searchHint => 'Search items or PIC...';

  @override
  String get notificationTitle => 'Test Notification';

  @override
  String get notificationBody => 'This is a test notification.';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String exportSuccess(Object path) {
    return 'Exported to $path';
  }

  @override
  String get exportTooltip => 'Export to Excel';

  @override
  String get switchToLightMode => 'Switch to Light Mode';

  @override
  String get switchToDarkMode => 'Switch to Dark Mode';

  @override
  String get changeYearTooltip => 'Change Year';

  @override
  String get viewReportsTooltip => 'View Reports';

  @override
  String noItemsFound(Object year) {
    return 'No items found for $year';
  }

  @override
  String get tryAddingItems => 'Try adding items or adjusting your search';

  @override
  String get addItem => 'Add Item';

  @override
  String budgetManagementTitle(Object year) {
    return 'Budget Management $year';
  }

  @override
  String get yearSelectionTitle => 'Select Year';

  @override
  String get enterYear => 'Enter Year';

  @override
  String get select => 'Select';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get delete => 'Delete';

  @override
  String get itemName => 'Item Name';

  @override
  String get plannedAmount => 'Planned Amount';

  @override
  String get soNumber => 'SO No';

  @override
  String get picName => 'PIC Name';

  @override
  String get description => 'Description';

  @override
  String get actualAmount => 'Actual Amount';

  @override
  String get status => 'Status';

  @override
  String get actions => 'Actions';

  @override
  String get newItem => 'New Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get save => 'Save';

  @override
  String get pleaseEnterItemName => 'Please enter item name';

  @override
  String get pleaseEnterPlannedAmount => 'Please enter planned amount';

  @override
  String get pleaseEnterPicName => 'Please enter PIC name';

  @override
  String get reports => 'Reports';

  @override
  String get totalBudget => 'Total Budget';

  @override
  String get totalUsed => 'Total Used';

  @override
  String get totalActual => 'Total Actual';

  @override
  String get remaining => 'Remaining';

  @override
  String get budgetRealization => 'Budget Realization';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get monthlyTrend => 'Monthly Trend';

  @override
  String get noData => 'No data available';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get selectBudgetYear => 'Select Budget Year';

  @override
  String get selectBudgetYearTitle => 'Budget Management App';

  @override
  String get selectBudgetYearSubtitle =>
      'Please select the budget year to get started';

  @override
  String get budgetYearLabel => 'Budget Year';

  @override
  String get budgetYearHint => 'Enter year (e.g., 2025)';

  @override
  String get pleaseEnterYear => 'Please enter a year';

  @override
  String get pleaseEnterValidYear => 'Please enter a valid year';

  @override
  String get continueToApp => 'Continue to Budget Management';

  @override
  String get selectYearForReport => 'Select Year for Report';

  @override
  String get noBudgetData => 'No budget data available';

  @override
  String get addBudgetItemsFirst => 'Add some budget items first';

  @override
  String reportForYear(Object year) {
    return 'Report for $year';
  }

  @override
  String reportTitle(Object year) {
    return 'Report $year';
  }

  @override
  String get noBudgetDataForYear => 'No budget data for this year';

  @override
  String budgetReportTitle(Object year) {
    return 'Budget Report $year';
  }

  @override
  String get usagePercentage => 'Usage %';

  @override
  String get summary => 'Summary';

  @override
  String get totalItems => 'Total Items';

  @override
  String get overallUsage => 'Overall Usage';

  @override
  String get pagu => 'Pagu';

  @override
  String get january => 'Jan';

  @override
  String get february => 'Feb';

  @override
  String get march => 'Mar';

  @override
  String get april => 'Apr';

  @override
  String get may => 'May';

  @override
  String get june => 'Jun';

  @override
  String get july => 'Jul';

  @override
  String get august => 'Aug';

  @override
  String get september => 'Sep';

  @override
  String get october => 'Oct';

  @override
  String get november => 'Nov';

  @override
  String get december => 'Dec';

  @override
  String get sisa => 'Sisa';

  @override
  String get input => 'Input';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deleteConfirmationMessage(Object itemName) {
    return 'Are you sure you want to delete \"$itemName\"?';
  }

  @override
  String get addNewBudgetItem => 'Add New Budget Item';

  @override
  String get fillInDetails => 'Fill in the details below';

  @override
  String get enterItemName => 'Enter item name...';

  @override
  String get picLabel => 'Person in Charge (PIC)';

  @override
  String get enterPicName => 'Enter PIC name...';

  @override
  String get yearlyBudgetLabel => 'Yearly Budget';

  @override
  String get enterAmountHint => 'Enter amount...';

  @override
  String get frequencyLabel => 'Frequency (times a year)';

  @override
  String get frequencyHint => 'Enter frequency (1-12)...';

  @override
  String get pleaseEnterFrequency => 'Please enter a frequency';

  @override
  String get pleaseEnterValidFrequency =>
      'Please enter a number between 1 and 12';

  @override
  String get selectActiveMonths => 'Select Active Months:';

  @override
  String maxMonthsSelection(Object frequency) {
    return 'You can only select $frequency months.';
  }

  @override
  String selectExactlyMonths(Object frequency) {
    return 'Please select exactly $frequency months.';
  }

  @override
  String get saveItem => 'Save Item';

  @override
  String get editBudgetItem => 'Edit Budget Item';

  @override
  String get updateItemDetails => 'Update the item details below';

  @override
  String get updateItem => 'Update Item';

  @override
  String budgetLessThanUsed(Object amount) {
    return 'Yearly budget cannot be less than total used amount ($amount)';
  }

  @override
  String updateAmountFor(Object itemName) {
    return 'Update Amount for $itemName';
  }

  @override
  String monthLabel(Object month) {
    return 'Month: $month';
  }

  @override
  String get remainingBudget => 'Remaining Budget';

  @override
  String get amountLabel => 'Amount';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get amountExceedsRemaining => 'Amount exceeds remaining budget';

  @override
  String get budgetApp => 'Budget App';
}
