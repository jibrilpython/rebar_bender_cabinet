import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  User Provider — manages firstTimeUser flag
// ─────────────────────────────────────────────────────────────────────────────

class UserNotifier extends ChangeNotifier {
  bool firstTimeUser = true;
  static const _key = 'rba_first_time_user';

  Future<void> loadUser(SharedPreferences prefs) async {
    firstTimeUser = prefs.getBool(_key) ?? true;
    notifyListeners();
  }

  Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    firstTimeUser = false;
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier();
});
