import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/layout/layout_scaffold.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/pages/auth/login.dart';
import 'package:mtg_scanner/pages/auth/register.dart';
import 'package:mtg_scanner/pages/card_details.dart';
import 'package:mtg_scanner/pages/collection.dart';
import 'package:mtg_scanner/pages/detect_edge.dart';
import 'package:mtg_scanner/pages/settings.dart';
import 'package:mtg_scanner/router/routes.dart';
import 'package:mtg_scanner/utils/dialogs.dart';

final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Root Navigator');
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/collection',
  routes: [
    // collection tab
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      // animate the transition between tabs

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.collection,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const Collection(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.search,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const DetectEdge(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) => const Settings(),
            ),
          ],
        )
      ],
    ),
    GoRoute(
      path: Routes.cardDetails,
      builder: (context, state) => CardDetails(state.extra as mtg.Card),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => const Login()),
    GoRoute(
        path: Routes.register, builder: (context, state) => const Register()),

    GoRoute(
        path: Routes.showDialog,
        pageBuilder: (context, state) {
          final title = state.pathParameters['title']!;
          final message = state.pathParameters['message']!;
          return Dialogs.customDialog(title: title, message: message);
        }),
  ],
);
