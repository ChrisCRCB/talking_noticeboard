// ignore_for_file: avoid_catching_errors
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

/// Provide an HTTP client.
final dioProvider = Provider((final ref) => Dio());

/// Provide the shared preferences instance.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (final ref) => SharedPreferences.getInstance(),
);

/// Provide the server URL.
final urlProvider = FutureProvider<String?>(
  (final ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    final url = sharedPreferences.getString(urlPreferencesKey);
    if (url == null || url.isEmpty) {
      return null;
    }
    return url;
  },
);

/// Provide the authorization string.
final authorizationStringProvider = FutureProvider<String?>(
  (final ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return sharedPreferences.getString(authorizationPreferencesKey);
  },
);
