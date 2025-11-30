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
                  const Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Budget',
                          _formatAmount(totalBudget),
                          Icons.account_balance_wallet_outlined,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Used',
                          _formatAmount(totalUsed),
                          Icons.trending_up_outlined,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Remaining',
                          _formatAmount(totalRemaining),
                          Icons.trending_down_outlined,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Items Count',
                          itemsForCurrentYear.length.toString(),
                          Icons.list_alt_outlined,
                          Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Utilization',
                          totalBudget > 0 
                            ? '${((totalUsed / totalBudget) * 100).toStringAsFixed(1)}%' 
                            : '0%',
                          Icons.bar_chart_outlined,
                          Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Upcoming Items Section by PIC
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications_active_outlined),
                            const SizedBox(width: 8),
                            Text(
                              'Next Upcoming Items by PIC',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (nextUpcomingByPic.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No upcoming budget items scheduled',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: nextUpcomingByPic.length,
                            itemBuilder: (context, index) {
                              final pic = nextUpcomingByPic.keys.elementAt(index);
                              final data = nextUpcomingByPic[pic]!;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(pic),
                                  subtitle: Text('Next in: ${data['monthName']} (${data['itemCount']} item${data['itemCount'] > 1 ? 's' : ''})'),
                                  trailing: Text(
                                    _formatAmount(data['item']?.yearlyBudget ?? 0),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Year Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Year',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                yearProvider.currentYear?.toString() ?? 'Not set',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const YearSelectionScreen(),
                                ),
                              );
                            },
                            child: const Text('Change Year'),
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
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}