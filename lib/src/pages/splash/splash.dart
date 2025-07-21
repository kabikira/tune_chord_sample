import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:tune_chord_sample/src/config/app_theme.dart';
import 'package:tune_chord_sample/src/widgets/resonance_icon.dart';

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
        child: const Center(child: SimpleResonanceIcon(size: 250)),
      ),
    );
  }
}
