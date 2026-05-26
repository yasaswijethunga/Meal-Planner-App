import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'is_dark_mode';

  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_key) == true ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await ref.read(sharedPreferencesProvider).setBool(_key, !isDark);
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
