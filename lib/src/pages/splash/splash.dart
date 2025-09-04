// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:chord_fracture/src/config/app_theme.dart';
import 'package:chord_fracture/src/widgets/chord_fracture_icon.dart';

class Splash extends HookWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    useEffect(() {
      // 遅延後に次の画面へ移動
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          context.go('/tuningList');
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeUtils.createGradientBackground(),
        ),
        child: const Center(child: SimpleChordFractureIcon(size: 250)),
      ),
    );
  }
}
