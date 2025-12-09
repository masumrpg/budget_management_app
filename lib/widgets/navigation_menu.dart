import 'package:flutter/material.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class NavigationMenuItem {
  final IconData icon;
  final String Function(BuildContext) getLabel;
  final int index;

  NavigationMenuItem({
    required this.icon,
    required this.getLabel,
    required this.index,
  });
}

class NavigationMenuItems {
  static List<NavigationMenuItem> getMenuItems(BuildContext context) {
    return [
      NavigationMenuItem(
        icon: Icons.home_outlined,
        getLabel: (context) => AppLocalizations.of(context)!.dashboard,
        index: 0,
      ),
      NavigationMenuItem(
        icon: Icons.table_chart_outlined,
        getLabel: (context) => AppLocalizations.of(context)!.appTitle,
        index: 1,
      ),
      NavigationMenuItem(
        icon: Icons.bar_chart_outlined,
        getLabel: (context) => AppLocalizations.of(context)!.reports,
        index: 2,
      ),
    ];
  }

  static Widget buildNavigationItem({
    required BuildContext context,
    required NavigationMenuItem item,
    required bool isSelected,
    required VoidCallback onTap,
    bool showLabel = true,
  }) {
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
          item.icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: showLabel
            ? Text(
                item.getLabel(context),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        selected: isSelected,
        onTap: onTap,
      ),
    );
  }
}
