import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

/// Provide the TTS system.
@riverpod
FlutterTts tts(final Ref ref) => FlutterTts();

/// Provide the shared preferences instance.
@riverpod
SharedPreferencesAsync sharedPreferences(
  final Ref ref,
) =>
    SharedPreferencesAsync();
