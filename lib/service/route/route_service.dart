import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:password_vault/feature/auth/login.dart';
import 'package:password_vault/feature/home.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/login', // Set initial location to login page
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Home(); // Default route, redirects to home page
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
            return const Home(); // Home page route
          },
        )
      ],
    ),
  ],
);
