import 'package:budget_management_app/screens/dashboard_overview_screen.dart';
import 'package:budget_management_app/screens/year_selection_report_screen.dart';
import 'package:budget_management_app/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart'; // Budget Management
import '../widgets/modern_sidebar.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  final bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DashboardOverviewScreen(),
      DashboardScreen(), // Budget Management
      const YearSelectionReportScreen(), // Reports
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 600 as breakpoint: mobile < 600, desktop >= 600
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Mobile layout with drawer
          return Scaffold(
            appBar: AppBar(title: Text(_getPageTitle(context))),
            drawer: _buildDrawer(context),
            body: IndexedStack(index: _selectedIndex, children: screens),
          );
        } else {
          // Desktop layout with sidebar
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
                  child: IndexedStack(index: _selectedIndex, children: screens),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String _getPageTitle(BuildContext context) {
    final menuItems = NavigationMenuItems.getMenuItems(context);
    if (_selectedIndex < menuItems.length) {
      return menuItems[_selectedIndex].getLabel(context);
    }
    return AppLocalizations.of(context)!.appTitle;
  }

  Widget _buildDrawer(BuildContext context) {
    final menuItems = NavigationMenuItems.getMenuItems(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Image.asset('assets/image/logo.png', height: 40, width: 40),
                  const SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context)!.budgetApp,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final bool isSelected = _selectedIndex == item.index;

                  return NavigationMenuItems.buildNavigationItem(
                    context: context,
                    item: item,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedIndex = item.index;
                      });
                      Navigator.pop(context); // Close drawer
                    },
                    showLabel: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}