import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (index) {
              // 同じタブをタップした場合はルートに戻る
              if (index == widget.navigationShell.currentIndex) {
                switch (index) {
                  case 0:
                    context.go('/tuningList');
                    break;
                  case 1:
                    context.go('/search');
                    break;
                  case 2:
                    context.go('/settings');
                    break;
                }
              } else {
                // 異なるタブをタップした場合は通常通りブランチを切り替える
                widget.navigationShell.goBranch(index);
              }
            },
            backgroundColor: Colors.white,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withValues(
              alpha: 153,
            ),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              _buildNavBarItem(
                icon: Icons.music_note,
                activeIcon: Icons.music_note,
                label: AppLocalizations.of(context)!.navTuning,
                index: 0,
              ),
              _buildNavBarItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: AppLocalizations.of(context)!.navSearch,
                index: 1,
              ),
              _buildNavBarItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: AppLocalizations.of(context)!.navSettings,
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ナビゲーションバー項目を構築するヘルパーメソッド
  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = widget.navigationShell.currentIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(isSelected ? activeIcon : icon),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
