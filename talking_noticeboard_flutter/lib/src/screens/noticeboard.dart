import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../../gen/assets.gen.dart';
import '../client.dart';
import '../widgets/custom_text.dart';

/// A [ListView] which shows notices.
class Noticeboard extends StatefulWidget {
  /// Create an instance.
  const Noticeboard({
    this.loadInterval = const Duration(minutes: 1),
    this.skipNoticesDuration = const Duration(seconds: 5),
    super.key,
  });

  /// How often notices should be reloaded.
  final Duration loadInterval;

  /// How often notices can be skipped.
  final Duration skipNoticesDuration;

  /// Create state for this widget.
  @override
  NoticeboardState createState() => NoticeboardState();
}

/// State for [Noticeboard].
class NoticeboardState extends State<Noticeboard> {
  /// An error object.
  Object? _error;

  /// A stack trace.
  StackTrace? _stackTrace;

  /// The currently-loaded notices.
  List<Notice>? _notices;

  /// The time since the notices were last loaded.
  late DateTime _lastLoaded;

  /// The index of the current notice.
  late int index;

  /// The currently playing sound.
  SoundHandle? _soundHandle;

  /// The last time notices were skipped.
  DateTime? _lastSkip;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    index = 0;
    _lastLoaded = DateTime.now();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      Timer(
        const Duration(seconds: 30),
        () => setState(() {
          _error = null;
          _stackTrace = null;
          _notices = null;
        }),
      );
      return ErrorScreen(
        error: error,
        stackTrace: _stackTrace,
      );
    }
    final notices = _notices;
    if (notices == null ||
        DateTime.now().difference(_lastLoaded) > widget.loadInterval) {
      client.notices
          .getNotices()
          .then(
            (final value) => setState(() {
              _error = null;
              _stackTrace = null;
              _lastLoaded = DateTime.now();
              _notices = value;
            }),
          )
          .onError(handleError);
      return const LoadingScreen();
    }
    final Widget child;
    if (notices.isEmpty) {
      _notices = null;
      child = const Material(
        child: CustomText('There are no notices to show.'),
      );
    } else {
      if (index >= notices.length) {
        index = 0;
      }
      final notice = notices[index];
      _soundHandle?.stop();
      _soundHandle = null;
      context
          .playSound(
            Sound(
              path: notice.filename,
              soundType: SoundType.custom,
              destroy: false,
            ),
          )
          .then((final soundHandle) => _soundHandle = soundHandle)
          .onError(handleError);
      child = Material(
        child: AutoSizeText(notice.text),
      );
    }
    return Focus(
      autofocus: true,
      onKeyEvent: (final node, final event) {
        final lastSkip = _lastSkip;
        final now = DateTime.now();
        if (lastSkip == null ||
            now.difference(lastSkip) > widget.skipNoticesDuration) {
          setState(() {
            _lastSkip = now;
            index++;
          });
        }
        return KeyEventResult.handled;
      },
      child: child,
    );
  }

  /// Handle an error.
  Future<SoundHandle> handleError(
    final Object error,
    final StackTrace stackTrace,
  ) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });
    if (mounted) {
      return context.playSound(
        Assets.sounds.error.asSound(
          destroy: false,
          soundType: SoundType.asset,
        ),
      );
    }
    throw StateError('The context is no longer mounted.');
  }
}
