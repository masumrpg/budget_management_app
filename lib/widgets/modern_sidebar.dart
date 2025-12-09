import 'package:flutter/material.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class ModernSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemPressed;
  final bool isExpanded;

  const ModernSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemPressed,
    required this.isExpanded,
  });

  @override
  State<ModernSidebar> createState() => _ModernSidebarState();
}

class _ModernSidebarState extends State<ModernSidebar> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.home_outlined,
        'label': AppLocalizations.of(context)!.dashboard,
        'index': 0,
      },
      {
        'icon': Icons.table_chart_outlined,
        'label': AppLocalizations.of(context)!.appTitle,
        'index': 1,
      },
      {
        'icon': Icons.bar_chart_outlined,
        'label': AppLocalizations.of(context)!.reports,
        'index': 2,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      width: widget.isExpanded ? 250 : 80,
      child: SafeArea(
        child: Column(
          children: [
            // App Title
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset('assets/image/logo.png', height: 32, width: 32,
                  ),
                  if (widget.isExpanded)
                    const SizedBox(width: 12),
                  if (widget.isExpanded)
                    Text(
                      AppLocalizations.of(context)!.budgetApp,
                      style: const TextStyle(
                        fontSize: 18,
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
                  final bool isSelected = widget.selectedIndex == item['index'];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      leading: Icon(
                        item['icon'],
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: widget.isExpanded
                          ? Text(
                              item['label'],
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      selected: isSelected,
                      onTap: () => widget.onItemPressed(item['index'] as int),
                    ),
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