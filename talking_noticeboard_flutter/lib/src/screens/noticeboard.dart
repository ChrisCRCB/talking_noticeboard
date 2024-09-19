import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.playLocationInterval = const Duration(minutes: 1),
    this.canPop = false,
    super.key,
  });

  /// How often notices should be reloaded.
  final Duration loadInterval;

  /// How often notices can be skipped.
  final Duration skipNoticesDuration;

  /// How often the location sound should play.
  final Duration playLocationInterval;

  /// Whether the widget can be popped with the escape key.
  final bool canPop;

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

  /// The currently playing notice sound.
  SoundHandle? _noticeSoundHandle;

  /// The last time notices were skipped.
  DateTime? _lastSkip;

  /// The location timer.
  late Timer locationTimer;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    index = 0;
    _lastLoaded = DateTime.now();
    locationTimer = Timer.periodic(
      widget.playLocationInterval,
      (final timer) => playLocationSound(),
    );
  }

  /// Play the location ping.
  void playLocationSound() {
    if (context.mounted) {
      context.playSound(
        Assets.sounds.location
            .asSound(destroy: true, soundType: SoundType.asset),
      );
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _noticeSoundHandle?.stop();
    locationTimer.cancel();
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
              resetTimes();
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
      _noticeSoundHandle?.stop();
      _noticeSoundHandle = null;
      context
          .playSound(
        Sound(
          path: notice.path,
          soundType: SoundType.custom,
          destroy: false,
        ),
      )
          .then((final soundHandle) {
        _error = null;
        _stackTrace = null;
        resetTimes();
        _noticeSoundHandle = soundHandle;
        return soundHandle;
      }).onError(handleError);
      child = Material(
        child: AutoSizeText(notice.text),
      );
    }
    return Focus(
      autofocus: true,
      onKeyEvent: (final node, final event) {
        if (widget.canPop && event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
          return KeyEventResult.handled;
        }
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

  /// Reset the times to now.
  void resetTimes() {
    _lastLoaded = DateTime.now();
    _lastSkip = _lastLoaded;
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
