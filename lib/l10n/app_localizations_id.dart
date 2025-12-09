// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Manajemen Anggaran';

  @override
  String get searchHint => 'Cari item atau PIC...';

  @override
  String get notificationTitle => 'Notifikasi Uji Coba';

  @override
  String get notificationBody => 'Ini adalah notifikasi uji coba.';

  @override
  String get notificationsTooltip => 'Notifikasi';

  @override
  String exportSuccess(Object path) {
    return 'Diekspor ke $path';
  }

  @override
  String get exportTooltip => 'Ekspor ke Excel';

  @override
  String get switchToLightMode => 'Ganti ke Mode Terang';

  @override
  String get switchToDarkMode => 'Ganti ke Mode Gelap';

  @override
  String get changeYearTooltip => 'Ganti Tahun';

  @override
  String get viewReportsTooltip => 'Lihat Laporan';

  @override
  String noItemsFound(Object year) {
    return 'Tidak ada item ditemukan untuk $year';
  }

  @override
  String get tryAddingItems =>
      'Coba tambahkan item atau sesuaikan pencarian Anda';

  @override
  String get addItem => 'Tambah Item';

  @override
  String budgetManagementTitle(Object year) {
    return 'Manajemen Anggaran $year';
  }

  @override
  String get yearSelectionTitle => 'Pilih Tahun';

  @override
  String get enterYear => 'Masukkan Tahun';

  @override
  String get select => 'Pilih';

  @override
  String get cancel => 'Batal';

  @override
  String get ok => 'OK';

  @override
  String get deleteItem => 'Hapus Item';

  @override
  String get deleteConfirmation =>
      'Apakah Anda yakin ingin menghapus item ini?';

  @override
  String get delete => 'Hapus';

  @override
  String get itemName => 'Nama Item';

  @override
  String get plannedAmount => 'Jumlah Direncanakan';

  @override
  String get soNumber => 'No SO';

  @override
  String get picName => 'Nama PIC';

  @override
  String get description => 'Deskripsi';

  @override
  String get actualAmount => 'Jumlah Aktual';

  @override
  String get status => 'Status';

  @override
  String get actions => 'Aksi';

  @override
  String get newItem => 'Item Baru';

  @override
  String get editItem => 'Edit Item';

  @override
  String get save => 'Simpan';

  @override
  String get pleaseEnterItemName => 'Mohon masukkan nama item';

  @override
  String get pleaseEnterPlannedAmount => 'Mohon masukkan jumlah direncanakan';

  @override
  String get pleaseEnterPicName => 'Mohon masukkan nama PIC';

  @override
  String get reports => 'Laporan';

  @override
  String get totalBudget => 'Total Anggaran';

  @override
  String get totalUsed => 'Total Terpakai';

  @override
  String get totalActual => 'Total Aktual';

  @override
  String get remaining => 'Sisa';

  @override
  String get budgetRealization => 'Realisasi Anggaran';

  @override
  String get expenseBreakdown => 'Rincian Pengeluaran';

  @override
  String get monthlyTrend => 'Tren Bulanan';

  @override
  String get noData => 'Tidak ada data tersedia';

  @override
  String get dashboard => 'Dasbor';

  @override
  String get selectBudgetYear => 'Pilih Tahun Anggaran';

  @override
  String get selectBudgetYearTitle => 'Aplikasi Manajemen Anggaran';

  @override
  String get selectBudgetYearSubtitle =>
      'Silakan pilih tahun anggaran untuk memulai';

  @override
  String get budgetYearLabel => 'Tahun Anggaran';

  @override
  String get budgetYearHint => 'Masukkan tahun (cth. 2025)';

  @override
  String get pleaseEnterYear => 'Mohon masukkan tahun';

  @override
  String get pleaseEnterValidYear => 'Mohon masukkan tahun yang valid';

  @override
  String get continueToApp => 'Lanjutkan ke Manajemen Anggaran';

  @override
  String get selectYearForReport => 'Pilih Tahun untuk Laporan';

  @override
  String get noBudgetData => 'Data anggaran tidak tersedia';

  @override
  String get addBudgetItemsFirst => 'Tambahkan item anggaran terlebih dahulu';

  @override
  String reportForYear(Object year) {
    return 'Laporan untuk $year';
  }

  @override
  String reportTitle(Object year) {
    return 'Laporan $year';
  }

  @override
  String get noBudgetDataForYear => 'Tidak ada data anggaran untuk tahun ini';

  @override
  String budgetReportTitle(Object year) {
    return 'Laporan Anggaran $year';
  }

  @override
  String get usagePercentage => '% Penggunaan';

  @override
  String get summary => 'Ringkasan';

  @override
  String get totalItems => 'Total Item';

  @override
  String get overallUsage => 'Penggunaan Keseluruhan';

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
  String get may => 'Mei';

  @override
  String get june => 'Jun';

  @override
  String get july => 'Jul';

  @override
  String get august => 'Ags';

  @override
  String get september => 'Sep';

  @override
  String get october => 'Okt';

  @override
  String get november => 'Nov';

  @override
  String get december => 'Des';

  @override
  String get sisa => 'Sisa';

  @override
  String get input => 'Input';

  @override
  String get confirmDelete => 'Konfirmasi Hapus';

  @override
  String deleteConfirmationMessage(Object itemName) {
    return 'Apakah Anda yakin ingin menghapus \"$itemName\"?';
  }

  @override
  String get budgetExhausted => 'Habis';

  @override
  String get addNewBudgetItem => 'Tambah Item Anggaran Baru';

  @override
  String get fillInDetails => 'Isi detail di bawah ini';

  @override
  String get enterItemName => 'Masukkan nama item...';

  @override
  String get picLabel => 'Person in Charge (PIC)';

  @override
  String get enterPicName => 'Masukkan nama PIC...';

  @override
  String get yearlyBudgetLabel => 'Anggaran Tahunan';

  @override
  String get enterAmountHint => 'Masukkan jumlah...';

  @override
  String get frequencyLabel => 'Frekuensi (kali per tahun)';

  @override
  String get frequencyHint => 'Masukkan frekuensi (1-12)...';

  @override
  String get pleaseEnterFrequency => 'Mohon masukkan frekuensi';

  @override
  String get pleaseEnterValidFrequency =>
      'Mohon masukkan angka antara 1 dan 12';

  @override
  String get selectActiveMonths => 'Pilih Bulan Aktif:';

  @override
  String maxMonthsSelection(Object frequency) {
    return 'Anda hanya dapat memilih $frequency bulan.';
  }

  @override
  String selectExactlyMonths(Object frequency) {
    return 'Mohon pilih tepat $frequency bulan.';
  }

  @override
  String get saveItem => 'Simpan Item';

  @override
  String get editBudgetItem => 'Edit Item Anggaran';

  @override
  String get updateItemDetails => 'Perbarui detail item di bawah ini';

  @override
  String get updateItem => 'Perbarui Item';

  @override
  String budgetLessThanUsed(Object amount) {
    return 'Anggaran tahunan tidak boleh kurang dari total yang digunakan ($amount)';
  }

  @override
  String updateAmountFor(Object itemName) {
    return 'Perbarui Jumlah untuk $itemName';
  }

  @override
  String monthLabel(Object month) {
    return 'Bulan: $month';
  }

  @override
  String get remainingBudget => 'Sisa Anggaran';

  @override
  String get amountLabel => 'Jumlah';

  @override
  String get pleaseEnterAmount => 'Mohon masukkan jumlah';

  @override
  String get pleaseEnterValidNumber => 'Mohon masukkan angka yang valid';

  @override
  String get amountExceedsRemaining => 'Jumlah melebihi sisa anggaran';

  @override
  String get budgetApp => 'Aplikasi Anggaran';
}
