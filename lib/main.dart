// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/firebase_options.dart';
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/config/app_theme.dart';
import 'package:chord_fracture/src/config/theme_provider.dart';
import 'package:chord_fracture/src/router/router.dart';
import 'package:chord_fracture/src/manager/app_initialization_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final appInitAsync = ref.watch(appInitializationNotifierProvider);

    return themeModeAsync.when(
      loading: () => _buildLoadingApp(),
      error: (error, stack) => _buildErrorApp(error, stack),
      data: (themeMode) {
        return appInitAsync.when(
          loading:
              () => _buildAppWithTheme(
                themeMode,
                const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('アプリを初期化しています...'),
                      ],
                    ),
                  ),
                ),
              ),
          error: (error, stack) {
            if (kDebugMode) {
              debugPrint('App initialization error: $error');
              debugPrint('Stack trace: $stack');
            }
            return _buildAppWithTheme(
              themeMode,
              Scaffold(
                body: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n?.generalError ?? 'An error occurred'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref
                                        .read(
                                          appInitializationNotifierProvider
                                              .notifier,
                                        )
                                        .reinitialize(),
                            child: const Text('再試行'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
          data: (result) {
            switch (result.status) {
              case AppInitializationStatus.loading:
                return _buildAppWithTheme(
                  themeMode,
                  const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              case AppInitializationStatus.firstLaunch:
                if (kDebugMode) {
                  debugPrint('First launch detected - sample data inserted');
                }
                return _buildMainApp(themeMode);
              case AppInitializationStatus.completed:
                return _buildMainApp(themeMode);
              case AppInitializationStatus.error:
                return _buildAppWithTheme(
                  themeMode,
                  Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('初期化エラー: ${result.errorMessage}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref
                                        .read(
                                          appInitializationNotifierProvider
                                              .notifier,
                                        )
                                        .reinitialize(),
                            child: const Text('再試行'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildErrorApp(Object error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('Theme initialization error: $error');
      debugPrint('Stack trace: $stack');
    }
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return Center(
              child: Text(l10n?.generalError ?? 'An error occurred'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppWithTheme(ThemeMode themeMode, Widget home) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: home,
    );
  }

  Widget _buildMainApp(ThemeMode themeMode) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
