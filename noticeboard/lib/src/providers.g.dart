// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ttsHash() => r'1d6ce0c7d32aabc12b4a43f6eab894740fe66541';

/// Provide the TTS system.
///
/// Copied from [tts].
@ProviderFor(tts)
final ttsProvider = AutoDisposeProvider<FlutterTts>.internal(
  tts,
  name: r'ttsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ttsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TtsRef = AutoDisposeProviderRef<FlutterTts>;
String _$sharedPreferencesHash() => r'c0d827a60771a7c37a7c0952274b865aca9b7784';

/// Provide the shared preferences instance.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeProvider<SharedPreferencesAsync>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeProviderRef<SharedPreferencesAsync>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
