import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_vault/feature/auth/auth.dart';
import 'package:password_vault/feature/auth/login.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/route/bottom_nav_route.dart';

final loginProvider = FutureProvider<bool>((ref) async {
  var isFirstLogin = await CacheService().checkIsFirstLogin();
  return isFirstLogin;
});
final navigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context, WidgetRef ref) {

  bool checkFirstLogin()  {
  var isFirstLogin = true;
  ref.watch(loginProvider).whenData((value) {
    isFirstLogin = value;
  });
  return isFirstLogin;
}

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: checkFirstLogin() ? '/login' : '/auth',
   //initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const NavRoute(); // Default route, redirects to home page
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
              return const NavRoute(); // Home page route with selectedIndex 0
            },
          ),
          GoRoute(
            path: 'passwords',
            builder: (BuildContext context, GoRouterState state) {
              return const NavRoute(); // Passwords page route with selectedIndex 1
            },
          ),
          GoRoute(
            path: 'auth',
            builder: (BuildContext context, GoRouterState state) {
              return const AuthScreen(); // Auth page route
            },
          ),
        ],
      ),
    ],
  );
}

