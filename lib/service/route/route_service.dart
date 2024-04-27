import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/feature/auth/login.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/route/bottom_nav_route.dart';

final passwordsProvider = FutureProvider<List<PasswordModel>>((ref) async {
  // Load favourites from cache
  List<PasswordModel> favourites = [];
  favourites = await CacheService().getPasswordsData();
  return favourites;
});


final navigatorKey = GlobalKey<NavigatorState>();
GoRouter createRouter(BuildContext context, WidgetRef ref) {
  
  bool checkData()  {
  var passwords=  [];
  ref.watch(passwordsProvider).whenData((value) {
    passwords = value;
  });
  return passwords.isNotEmpty;
}

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: checkData() ? '/homePage' : '/login',
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
          )
        ],
      ),
    ],
  );
}

