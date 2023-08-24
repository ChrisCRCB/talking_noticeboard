import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'noticeboard_screen.dart';
import 'url_screen.dart';

/// The main screen for the app.
class MainScreen extends ConsumerWidget {
  /// Create an instance.
  const MainScreen({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(urlProvider);
    return value.when(
      data: (final baseUrl) {
        if (baseUrl == null) {
          return const UrlScreen();
        }
        final value = ref.watch(authorizationStringProvider);
        return value.when(
          data: (final authorizationString) => NoticeboardScreen(
            baseUrl: baseUrl,
            authorizationString: authorizationString,
          ),
          error: ErrorScreen.withPositional,
          loading: LoadingScreen.new,
        );
      },
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
