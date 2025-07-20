import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.05),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.music_note,
            size: 80,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
