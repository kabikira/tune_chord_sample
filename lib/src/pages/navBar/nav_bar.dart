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
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'TuningList',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
