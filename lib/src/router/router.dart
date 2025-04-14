import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_detail.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_edit.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_list.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_register.dart';
import 'package:tune_chord_sample/src/pages/navBar/nav_bar.dart';
import 'package:tune_chord_sample/src/pages/settings/settings.dart';
import 'package:tune_chord_sample/src/pages/splash/splash.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_list.dart';
import 'package:tune_chord_sample/src/router/router_observer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _tuningNavKey = GlobalKey<NavigatorState>();
final _settingsNavKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  observers: [RouterObserver()],
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const Splash()),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _tuningNavKey,
          observers: [RouterObserver()],
          routes: [
            GoRoute(
              path: '/tuningList',
              builder: (context, state) => const TuningList(),
              routes: [
                GoRoute(
                  path: 'codeFormList/:tuningId',
                  builder: (context, state) {
                    final tuningId = int.parse(
                      state.pathParameters['tuningId']!,
                    );
                    return CodeFormList(tuningId: tuningId);
                  },
                  routes: [
                    GoRoute(
                      path: 'codeFormRegister',
                      builder: (context, state) => const CodeFormRegister(),
                    ),
                    GoRoute(
                      path: 'codeFormDetail',
                      builder: (context, state) => const CodeFormDetail(),
                      routes: [
                        GoRoute(
                          path: 'codeFormEdit',
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
              path: '/settings',
              builder: (context, state) => const Settings(),
            ),
          ],
        ),
      ],
    ),
  ],
);
