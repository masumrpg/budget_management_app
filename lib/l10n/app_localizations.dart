import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search items or PIC...'**
  String get searchHint;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get notificationTitle;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'This is a test notification.'**
  String get notificationBody;

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String exportSuccess(Object path);

  /// No description provided for @exportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get exportTooltip;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchToDarkMode;

  /// No description provided for @changeYearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change Year'**
  String get changeYearTooltip;

  /// No description provided for @viewReportsTooltip.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReportsTooltip;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found for {year}'**
  String noItemsFound(Object year);

  /// No description provided for @tryAddingItems.
  ///
  /// In en, this message translates to:
  /// **'Try adding items or adjusting your search'**
  String get tryAddingItems;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @budgetManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Management {year}'**
  String budgetManagementTitle(Object year);

  /// No description provided for @yearSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get yearSelectionTitle;

  /// No description provided for @enterYear.
  ///
  /// In en, this message translates to:
  /// **'Enter Year'**
  String get enterYear;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @plannedAmount.
  ///
  /// In en, this message translates to:
  /// **'Planned Amount'**
  String get plannedAmount;

  /// No description provided for @soNumber.
  ///
  /// In en, this message translates to:
  /// **'SO No'**
  String get soNumber;

  /// No description provided for @picName.
  ///
  /// In en, this message translates to:
  /// **'PIC Name'**
  String get picName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @actualAmount.
  ///
  /// In en, this message translates to:
  /// **'Actual Amount'**
  String get actualAmount;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New Item'**
  String get newItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseEnterItemName.
  ///
  /// In en, this message translates to:
  /// **'Please enter item name'**
  String get pleaseEnterItemName;

  /// No description provided for @pleaseEnterPlannedAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter planned amount'**
  String get pleaseEnterPlannedAmount;

  /// No description provided for @pleaseEnterPicName.
  ///
  /// In en, this message translates to:
  /// **'Please enter PIC name'**
  String get pleaseEnterPicName;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @totalUsed.
  ///
  /// In en, this message translates to:
  /// **'Total Used'**
  String get totalUsed;

  /// No description provided for @totalActual.
  ///
  /// In en, this message translates to:
  /// **'Total Actual'**
  String get totalActual;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @budgetRealization.
  ///
  /// In en, this message translates to:
  /// **'Budget Realization'**
  String get budgetRealization;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @monthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trend'**
  String get monthlyTrend;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @selectBudgetYear.
  ///
  /// In en, this message translates to:
  /// **'Select Budget Year'**
  String get selectBudgetYear;

  /// No description provided for @selectBudgetYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Management App'**
  String get selectBudgetYearTitle;

  /// No description provided for @selectBudgetYearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please select the budget year to get started'**
  String get selectBudgetYearSubtitle;

  /// No description provided for @budgetYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Year'**
  String get budgetYearLabel;

  /// No description provided for @budgetYearHint.
  ///
  /// In en, this message translates to:
  /// **'Enter year (e.g., 2025)'**
  String get budgetYearHint;

  /// No description provided for @pleaseEnterYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter a year'**
  String get pleaseEnterYear;

  /// No description provided for @pleaseEnterValidYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get pleaseEnterValidYear;

  /// No description provided for @continueToApp.
  ///
  /// In en, this message translates to:
  /// **'Continue to Budget Management'**
  String get continueToApp;

  /// No description provided for @selectYearForReport.
  ///
  /// In en, this message translates to:
  /// **'Select Year for Report'**
  String get selectYearForReport;

  /// No description provided for @noBudgetData.
  ///
  /// In en, this message translates to:
  /// **'No budget data available'**
  String get noBudgetData;

  /// No description provided for @addBudgetItemsFirst.
  ///
  /// In en, this message translates to:
  /// **'Add some budget items first'**
  String get addBudgetItemsFirst;

  /// No description provided for @reportForYear.
  ///
  /// In en, this message translates to:
  /// **'Report for {year}'**
  String reportForYear(Object year);

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report {year}'**
  String reportTitle(Object year);

  /// No description provided for @noBudgetDataForYear.
  ///
  /// In en, this message translates to:
  /// **'No budget data for this year'**
  String get noBudgetDataForYear;

  /// No description provided for @budgetReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Report {year}'**
  String budgetReportTitle(Object year);

  /// No description provided for @usagePercentage.
  ///
  /// In en, this message translates to:
  /// **'Usage %'**
  String get usagePercentage;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @overallUsage.
  ///
  /// In en, this message translates to:
  /// **'Overall Usage'**
  String get overallUsage;

  /// No description provided for @pagu.
  ///
  /// In en, this message translates to:
  /// **'Pagu'**
  String get pagu;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get december;

  /// No description provided for @sisa.
  ///
  /// In en, this message translates to:
  /// **'Sisa'**
  String get sisa;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{itemName}\"?'**
  String deleteConfirmationMessage(Object itemName);

  /// No description provided for @budgetExhausted.
  ///
  /// In en, this message translates to:
  /// **'Exhausted'**
  String get budgetExhausted;

  /// No description provided for @addNewBudgetItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Budget Item'**
  String get addNewBudgetItem;

  /// No description provided for @fillInDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below'**
  String get fillInDetails;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter item name...'**
  String get enterItemName;

  /// No description provided for @picLabel.
  ///
  /// In en, this message translates to:
  /// **'Person in Charge (PIC)'**
  String get picLabel;

  /// No description provided for @enterPicName.
  ///
  /// In en, this message translates to:
  /// **'Enter PIC name...'**
  String get enterPicName;

  /// No description provided for @yearlyBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Yearly Budget'**
  String get yearlyBudgetLabel;

  /// No description provided for @enterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount...'**
  String get enterAmountHint;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency (times a year)'**
  String get frequencyLabel;

  /// No description provided for @frequencyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter frequency (1-12)...'**
  String get frequencyHint;

  /// No description provided for @pleaseEnterFrequency.
  ///
  /// In en, this message translates to:
  /// **'Please enter a frequency'**
  String get pleaseEnterFrequency;

  /// No description provided for @pleaseEnterValidFrequency.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number between 1 and 12'**
  String get pleaseEnterValidFrequency;

  /// No description provided for @selectActiveMonths.
  ///
  /// In en, this message translates to:
  /// **'Select Active Months:'**
  String get selectActiveMonths;

  /// No description provided for @maxMonthsSelection.
  ///
  /// In en, this message translates to:
  /// **'You can only select {frequency} months.'**
  String maxMonthsSelection(Object frequency);

  /// No description provided for @selectExactlyMonths.
  ///
  /// In en, this message translates to:
  /// **'Please select exactly {frequency} months.'**
  String selectExactlyMonths(Object frequency);

  /// No description provided for @saveItem.
  ///
  /// In en, this message translates to:
  /// **'Save Item'**
  String get saveItem;

  /// No description provided for @editBudgetItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget Item'**
  String get editBudgetItem;

  /// No description provided for @updateItemDetails.
  ///
  /// In en, this message translates to:
  /// **'Update the item details below'**
  String get updateItemDetails;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @budgetLessThanUsed.
  ///
  /// In en, this message translates to:
  /// **'Yearly budget cannot be less than total used amount ({amount})'**
  String budgetLessThanUsed(Object amount);

  /// No description provided for @updateAmountFor.
  ///
  /// In en, this message translates to:
  /// **'Update Amount for {itemName}'**
  String updateAmountFor(Object itemName);

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month: {month}'**
  String monthLabel(Object month);

  /// No description provided for @remainingBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining Budget'**
  String get remainingBudget;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @amountExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds remaining budget'**
  String get amountExceedsRemaining;

  /// No description provided for @budgetApp.
  ///
  /// In en, this message translates to:
  /// **'Budget App'**
  String get budgetApp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
