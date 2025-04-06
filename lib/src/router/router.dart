import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_detail.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_edit.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_list.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_register.dart';
import 'package:tune_chord_sample/src/pages/navBar/nav_bar.dart';
import 'package:tune_chord_sample/src/pages/settings/settings.dart';
import 'package:tune_chord_sample/src/pages/splash/splash.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_list.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_register.dart';
import 'package:tune_chord_sample/src/router/router_observer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _tuningNavKey = GlobalKey<NavigatorState>();
final _settingsNavKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  observers: [RouterObserver()],
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const Splash(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _tuningNavKey,
          observers: [RouterObserver()],
          routes: [
            GoRoute(
              path: RoutePaths.tuningList,
              builder: (context, state) => const TuningList(),
              routes: [
                // GoRoute(
                //   // チューニング登録
                //   path: RoutePaths.tuningRegisterSegment,
                //   builder: (context, state) => const TuningRegister(),
                // ),
                // コードフォームリスト
                GoRoute(
                  path: RoutePaths.codeFormListSegment,
                  builder: (context, state) => const CodeFormList(),
                  routes: [
                    // コードフォーム登録、
                    GoRoute(
                      path: RoutePaths.codeFormRegisterSegment,
                      builder: (context, state) => const CodeFormRegister(),
                    ),
                    // コードフォーム詳細、
                    GoRoute(
                      path: RoutePaths.codeFormDetailSegment,
                      builder: (context, state) => const CodeFormDetail(),
                      routes: [
                        GoRoute(
                          path: RoutePaths.codeFormEditSegment,
                          builder: (context, state) => const CodeFormEdit(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavKey,
          observers: [RouterObserver()],
          routes: [
            GoRoute(
              path: RoutePaths.settings,
              builder: (context, state) => const Settings(),
            ),
          ],
        ),
      ],
    ),
  ],
);
