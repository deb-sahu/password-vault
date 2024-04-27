import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_vault/app_container.dart';

class ThemeChangeService {
  bool? _themeChange;

  static final ThemeChangeService _singleton = ThemeChangeService._internal();

  factory ThemeChangeService() {
    return _singleton;
  }

  Future<void> initializeThemeChange(WidgetRef ref, bool? themeChange) async {
    if ( themeChange == null) {
      ref.watch(themeCacheProvider).whenData((data) {
      themeChange = data;
      });
    }
    _themeChange = themeChange ?? false;
  }

  bool getThemeChangeValue() {
    return _themeChange ?? false; // Provide a default value if _themeChange is null
  }

  void updateThemeChange(bool newValue) {
    _themeChange = newValue;
  }

  ThemeChangeService._internal();
}
