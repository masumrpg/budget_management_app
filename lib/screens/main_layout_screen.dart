import 'package:budget_management_app/screens/dashboard_overview_screen.dart';
import 'package:budget_management_app/screens/year_selection_report_screen.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart'; // Budget Management
import '../widgets/modern_sidebar.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DashboardOverviewScreen(),
      DashboardScreen(), // Budget Management
      const YearSelectionReportScreen(), // Reports
    ];

    return Scaffold(
      body: Row(
        children: [
          ModernSidebar(
            selectedIndex: _selectedIndex,
            onItemPressed: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            isExpanded: _isSidebarExpanded,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}