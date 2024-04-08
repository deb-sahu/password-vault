import 'package:password_vault/service/route/route_service.dart';
import 'package:password_vault/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PasswordVault extends StatefulWidget {
  const PasswordVault({Key? key}) : super(key: key);
  @override
  State<PasswordVault> createState() => _PasswordVaultState();
}

class _PasswordVaultState extends State<PasswordVault> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Audit Safe',
      debugShowCheckedModeBanner: false,
      //checkerboardOffscreenLayers: true,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('zh', ''),
      ],
      localizationsDelegates: _getLocalizationsDelegates(),
      localeResolutionCallback: (locale, supportedLocales) => _getLocale(locale, supportedLocales),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: EasyLoading.init(),
      routerConfig: router,
    );
  }

  List<LocalizationsDelegate> _getLocalizationsDelegates() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
  }

  Locale _getLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return supportedLocales.first;
    }
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
