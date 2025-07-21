// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:resonance/src/pages/chordForm/chord_form_detail.dart';
import 'package:resonance/src/pages/chordForm/chord_form_edit.dart';
import 'package:resonance/src/pages/chordForm/chord_form_list.dart';
import 'package:resonance/src/pages/chordForm/chord_form_register.dart';
import 'package:resonance/src/pages/navBar/nav_bar.dart';
import 'package:resonance/src/pages/search/search_page.dart';
import 'package:resonance/src/pages/settings/settings.dart';
import 'package:resonance/src/pages/splash/splash.dart';
import 'package:resonance/src/pages/tuning/tuning_list.dart';
import 'package:resonance/src/router/router_observer.dart';

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
                  path: 'chordFormList/:tuningId',
                  builder: (context, state) {
                    final tuningId = int.parse(
                      state.pathParameters['tuningId']!,
                    );
                    return ChordFormList(tuningId: tuningId);
                  },
                  routes: [
                    GoRoute(
                      path: 'chordFormRegister',
                      builder: (context, state) {
                        final tuningId = state.extra as int;
                        return ChordFormRegister(tuningId: tuningId);
                      },
                    ),
                    GoRoute(
                      path: 'chordFormDetail',
                      builder: (context, state) {
                        final chordFormId = state.extra as int;
                        return ChordFormDetail(chordFormId: chordFormId);
                      },
                    ),
                    GoRoute(
                      path: 'chordFormEdit',
                      builder: (context, state) {
                        final tuningId = int.parse(
                          state.pathParameters['tuningId']!,
                        );
                        final chordFormId = state.extra as int;
                        return ChordFormEdit(
                          chordFormId: chordFormId,
                          tuningId: tuningId,
                        );
                      },
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
