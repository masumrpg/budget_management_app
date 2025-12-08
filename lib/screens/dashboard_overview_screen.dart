import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/screens/year_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  @override
  State<DashboardOverviewScreen> createState() => _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  String _formatAmount(double amount) {
    if (amount >= 1000000000) { // 1 miliar
      return 'Rp ${(amount / 1000000000).toStringAsFixed(0)} M';
    } else if (amount >= 1000000) { // 1 juta
      return 'Rp ${(amount / 1000000).toStringAsFixed(0)} Jt';
    } else if (amount >= 1000) { // 1 ribu
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} Rb';
    } else {
      final formatter = NumberFormat('#,##0', 'id_ID');
      return 'Rp ${formatter.format(amount)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<BudgetProvider, YearProvider>(
          builder: (context, budgetProvider, yearProvider, child) {
            final itemsForCurrentYear = budgetProvider.getItemsForYear(
              yearProvider.currentYear ?? DateTime.now().year,
            );

            // Calculate totals
            double totalBudget = 0;
            double totalUsed = 0;
            double totalRemaining = 0;

            for (final item in itemsForCurrentYear) {
              totalBudget += item.yearlyBudget;
              totalUsed += item.totalUsed;
              totalRemaining += item.remaining;
            }

            // Find next month's items for each PIC
            final currentMonth = DateTime.now().month;
            final monthNames = [
              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
            ];

            // Group items by PIC to find their next upcoming month
            final Map<String, Map<String, dynamic>> nextUpcomingByPic = {};

            for (final item in itemsForCurrentYear) {
              // For each item, find its next available month
              int? nextMonthIndex;
              String? nextMonthName;

              // Check for the next 12 months after current month
              for (int i = 1; i <= 12; i++) {
                int targetMonth = ((currentMonth - 1 + i) % 12); // 0-based index
                if (item.activeMonths.contains(targetMonth) &&
                    (item.monthlyWithdrawals[targetMonth] ?? 0) == 0) {
                  nextMonthIndex = targetMonth;
                  nextMonthName = monthNames[targetMonth];
                  break;
                }
              }

              if (nextMonthIndex != null) {
                final pic = item.picName;

                // If this PIC doesn't have a next month yet, or if this item's next month is sooner
                if (!nextUpcomingByPic.containsKey(pic) ||
                    nextMonthIndex < nextUpcomingByPic[pic]!['monthIndex']) {
                  // Initialize or update the entry for this PIC
                  nextUpcomingByPic[pic] = {
                    'monthName': nextMonthName,
                    'monthIndex': nextMonthIndex,
                    'item': item, // Store the item with the nearest upcoming month
                    'itemCount': 1, // Initialize count
                  };
                } else if (nextUpcomingByPic[pic]!['monthIndex'] == nextMonthIndex) {
                  // If it's the same month, increment the count
                  nextUpcomingByPic[pic]!['itemCount'] = nextUpcomingByPic[pic]!['itemCount'] + 1;
                }
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Stats
                  Text(
                    'Dashboard Overview',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Total Budget',
                          _formatAmount(totalBudget),
                          Icons.account_balance_wallet_outlined,
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Total Used',
                          _formatAmount(totalUsed),
                          Icons.trending_up_outlined,
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Remaining',
                          _formatAmount(totalRemaining),
                          Icons.savings_outlined, // Changed icon
                          Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Items Count',
                          itemsForCurrentYear.length.toString(),
                          Icons.format_list_bulleted_outlined,
                          Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Utilization',
                          totalBudget > 0
                              ? '${((totalUsed / totalBudget) * 100).toStringAsFixed(1)}%'
                            : '0%',
                          Icons.pie_chart_outline_outlined,
                          Colors.purple.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Upcoming Items Section by PIC
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Upcoming Schedules',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (nextUpcomingByPic.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No upcoming budget items scheduled',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: nextUpcomingByPic.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: Colors.grey.shade100),
                            itemBuilder: (context, index) {
                              final pic = nextUpcomingByPic.keys.elementAt(index);
                              final data = nextUpcomingByPic[pic]!;

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  child: Text(
                                    pic.isNotEmpty ? pic[0].toUpperCase() : '?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  pic,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Next: ${data['monthName']}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${data['itemCount']} items',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Budget',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Text(
                                      _formatAmount(
                                        data['item']?.yearlyBudget ?? 0,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Year Selection
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Active Budget Year',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    yearProvider.currentYear?.toString() ??
                                        'Not set',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const YearSelectionScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_calendar_outlined,
                              size: 18,
                            ),
                            label: const Text('Change Year'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Slightly smaller to fit "M" or "Jt"
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}