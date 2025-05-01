import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class Splash extends HookWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // アニメーション用のコントローラー
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    // アイコンのアニメーション
    final iconAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
    );

    // テキストのアニメーション
    final textAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
        ),
      ),
    );

    // サブテキストのアニメーション
    final subtextAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      ),
    );

    useEffect(() {
      // アニメーションを開始
      animationController.forward();

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
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ロゴアイコン（フェードイン・スケールアニメーション）
              Transform.scale(
                scale: 0.8 + (iconAnimation * 0.2),
                child: Opacity(
                  opacity: iconAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // アプリ名（フェードインアニメーション）
              Opacity(
                opacity: textAnimation,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - textAnimation)),
                  child: Text(
                    'コードフォーム管理',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // サブタイトル（フェードインアニメーション）
              Opacity(
                opacity: subtextAnimation,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - subtextAnimation)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '変則チューニングのためのギターコードフォーム管理',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 64),

              // ローディングインジケーター
              Opacity(
                opacity: subtextAnimation,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
