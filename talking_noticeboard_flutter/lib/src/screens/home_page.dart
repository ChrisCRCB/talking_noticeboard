import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../client.dart';
import '../widgets/custom_text.dart';
import 'noticeboard.dart';
import 'notices_screen.dart';

/// The page to show.
enum PageToShow {
  /// Unset.
  unset,

  /// Noticeboard.
  noticeboard,

  /// Admin panel.
  admin,
}

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({
    this.initialSeconds = 10,
    super.key,
  });

  /// The number of seconds to wait before showing the noticeboard screen.
  final int initialSeconds;

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// A displayed error.
  Object? _error;

  /// A stack trace to show.
  StackTrace? _stackTrace;

  /// The page to show.
  late PageToShow page;

  /// The timer to use.
  late final Timer timer;

  /// The number of seconds before [page] is changed by the system.
  int? _remainingSeconds;

  /// Whether the [sessionManager] has been initialised yet.
  late bool _sessionManagerInitialised;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _sessionManagerInitialised = false;
    page = PageToShow.unset;
    _remainingSeconds = widget.initialSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (final t) {
      final remainingSeconds = _remainingSeconds;
      if (remainingSeconds == null) {
        return;
      }
      final newSeconds = max(0, remainingSeconds - 1);
      if (newSeconds == 0) {
        setState(() {
          if (_error == null) {
            page = PageToShow.noticeboard;
            _remainingSeconds = null;
          } else {
            _error = null;
            _stackTrace = null;
            _remainingSeconds = widget.initialSeconds;
          }
        });
      } else {
        setState(() {
          _remainingSeconds = newSeconds;
        });
      }
    });
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return SimpleScaffold(
        title: 'Error ($_remainingSeconds)',
        body: ErrorListView(
          error: error,
          stackTrace: _stackTrace,
        ),
      );
    }
    if (!_sessionManagerInitialised) {
      sessionManager
          .initialize()
          .then((final _) => setState(() => _sessionManagerInitialised = true))
          .onError(handleError);
      return const LoadingScreen();
    }
    switch (page) {
      case PageToShow.unset:
        return SimpleScaffold(
          title: 'Select Mode ($_remainingSeconds)',
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                autofocus: true,
                onPressed: () => setState(() {
                  page = PageToShow.admin;
                  _remainingSeconds = null;
                }),
                child: const CustomText('Admin: Edit notices'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  page = PageToShow.noticeboard;
                  _remainingSeconds = null;
                }),
                child: const CustomText('Noticeboard: Cycle through notices'),
              ),
            ],
          ),
        );
      case PageToShow.noticeboard:
        return const Noticeboard();
      case PageToShow.admin:
        return const NoticesScreen();
    }
  }

  /// Handle an [error].
  void handleError(final Object error, final StackTrace stackTrace) {
    _remainingSeconds = widget.initialSeconds;
    setState(() {
      page = PageToShow.unset;
      _error = error;
      _stackTrace = stackTrace;
    });
  }
}
