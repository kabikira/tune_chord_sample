import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int? _lastTappedIndex;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 13),
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
              final now = DateTime.now();

              // 同じタブを短時間内に2回タップした場合
              if (index == _lastTappedIndex &&
                  _lastTapTime != null &&
                  now.difference(_lastTapTime!).inMilliseconds < 500) {
                // 現在のブランチのルートに移動
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
                // タップ情報をリセット
                _lastTappedIndex = null;
                _lastTapTime = null;
              } else {
                // 異なるタブをタップした場合や初回タップの場合は通常通りブランチを切り替える
                widget.navigationShell.goBranch(index);

                // タップ情報を更新
                _lastTappedIndex = index;
                _lastTapTime = now;
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
                label: 'チューニング',
                index: 0,
              ),
              _buildNavBarItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: '検索',
                index: 1,
              ),
              _buildNavBarItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: '設定',
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
