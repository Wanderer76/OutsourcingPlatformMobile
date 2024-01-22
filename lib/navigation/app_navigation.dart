import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outsource_mobile/pages/chats.dart';
import 'package:outsource_mobile/pages/find_projects.dart';
import 'package:outsource_mobile/pages/login.dart';
import 'package:outsource_mobile/pages/my_projects.dart';
import 'package:outsource_mobile/pages/new_project.dart';

import '../pages/my_project_page.dart';
import '../pages/project_page.dart';
import '../wrapper/main_wrapper.dart';

class AppNavigation {
  AppNavigation._();
  static String initial = "/login";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigationMyProjects = GlobalKey<NavigatorState>(debugLabel: 'shellProjects');
  static final _shellNavigationSearchProjects = GlobalKey<NavigatorState>(debugLabel: 'shellSearchProjects');
  static final _shellNavigationChats = GlobalKey<NavigatorState>(debugLabel: 'shellChats');
  // static final _shellNavigatorHome =
  // GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  // static final _shellNavigatorSettings =
  // GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
              navigatorKey: _shellNavigationSearchProjects,
              routes: <RouteBase> [
                GoRoute(
                  path: "/find_projects",
                  name: "FindProjects",
                  builder: (BuildContext context, GoRouterState state) => FindProjectsView(),

                )
              ]
          ),
          StatefulShellBranch(
              navigatorKey: _shellNavigationMyProjects,
              routes: <RouteBase> [
                GoRoute(
                  path: "/my_projects",
                  name: "MyProjects",
                  builder: (BuildContext context, GoRouterState state) => MyProjects(),

                ),
                GoRoute(
                    path: "/my_project/:id",
                    name: "MyProject",
                    builder: (BuildContext context, GoRouterState state) => MyProjectPage(id: state.pathParameters['id'])
                ),
                GoRoute(
                    path: "/project/:id",
                    name: "Project",
                    builder: (BuildContext context, GoRouterState state) => ProjectPage(id: state.pathParameters['id'])
                ),
                GoRoute(
                    path: "/new_project",
                    name: "NewProject",
                    builder: (BuildContext context, GoRouterState state) => NewProject()
                ),
              ]
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigationChats,
            routes: <RouteBase> [
              GoRoute(
                path: "/chats",
                name: "Chats",
                builder: (BuildContext context, GoRouterState state) => ChatsView(),
              ),

            ]
          )

          /// Brach Home
          // StatefulShellBranch(
          //   navigatorKey: _shellNavigatorHome,
          //   routes: <RouteBase>[
          //     GoRoute(
          //       path: "/home",
          //       name: "Home",
          //       builder: (BuildContext context, GoRouterState state) =>
          //       const HomeView(),
          //       routes: [
          //         GoRoute(
          //           path: 'subHome',
          //           name: 'subHome',
          //           pageBuilder: (context, state) => CustomTransitionPage<void>(
          //             key: state.pageKey,
          //             child: const SubHomeView(),
          //             transitionsBuilder:
          //                 (context, animation, secondaryAnimation, child) =>
          //                 FadeTransition(opacity: animation, child: child),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          /// Brach Setting
          // StatefulShellBranch(
          //   navigatorKey: _shellNavigatorSettings,
          //   routes: <RouteBase>[
          //     GoRoute(
          //       path: "/settings",
          //       name: "Settings",
          //       builder: (BuildContext context, GoRouterState state) =>
          //       const SettingsView(),
          //       routes: [
          //         GoRoute(
          //           path: "subSetting",
          //           name: "subSetting",
          //           pageBuilder: (context, state) {
          //             return CustomTransitionPage<void>(
          //               key: state.pageKey,
          //               child: const SubSettingsView(),
          //               transitionsBuilder: (
          //                   context,
          //                   animation,
          //                   secondaryAnimation,
          //                   child,
          //                   ) =>
          //                   FadeTransition(opacity: animation, child: child),
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),

      /// Player
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        name: "Login",
        builder: (context, state) => LoginPage(
          key: state.pageKey,
        ),
      )
    ],
  );
}
