import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:password_vault/feature/auth/login.dart';
import 'package:password_vault/service/route/bottom_nav_route.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/login', // Set initial location to login page
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const NavRoute(selectedIndex: 0);// Default route, redirects to home page
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const Login(); // Login page route
          },
        ),
         GoRoute(
          path: 'homePage',
          builder: (BuildContext context, GoRouterState state) {
            return const NavRoute(selectedIndex: 0); // Home page route with selectedIndex 0
          },
        ),
        GoRoute(
          path: 'passwords',
          builder: (BuildContext context, GoRouterState state) {
            return const NavRoute(selectedIndex: 1); // Passwords page route with selectedIndex 1
          },
        )
      ],
    ),
  ],
);
