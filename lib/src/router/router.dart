import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_detail.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_edit.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_list.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_register.dart';
import 'package:tune_chord_sample/src/pages/navBar/nav_bar.dart';
import 'package:tune_chord_sample/src/pages/search/search_page.dart';
import 'package:tune_chord_sample/src/pages/settings/settings.dart';
import 'package:tune_chord_sample/src/pages/splash/splash.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_list.dart';
import 'package:tune_chord_sample/src/router/router_observer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _tuningNavKey = GlobalKey<NavigatorState>();
final _settingsNavKey = GlobalKey<NavigatorState>();
final _searchNavKey = GlobalKey<NavigatorState>();

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
                      builder: (context, state) {
                        final tuningId = state.extra as int;
                        return CodeFormRegister(tuningId: tuningId);
                      },
                    ),
                    GoRoute(
                      path: 'codeFormDetail',
                      builder: (context, state) {
                        final codeFormId = state.extra as int;
                        return CodeFormDetail(codeFormId: codeFormId);
                      },
                      routes: [
                        GoRoute(
                          path: 'codeFormEdit',
                          builder: (context, state) {
                            return CodeFormEdit();
                          },
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
          navigatorKey: _searchNavKey,
          observers: [RouterObserver()],
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
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
