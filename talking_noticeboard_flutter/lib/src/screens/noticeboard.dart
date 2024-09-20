import 'dart:async';
import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../../gen/assets.gen.dart';
import '../client.dart';
import '../widgets/notice_text.dart';

/// A [ListView] which shows notices.
class Noticeboard extends StatefulWidget {
  /// Create an instance.
  const Noticeboard({
    this.loadInterval = const Duration(minutes: 1),
    this.canPop = false,
    super.key,
  });

  /// How often notices should be reloaded.
  final Duration loadInterval;

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
  Timer? _locationTimer;

  /// The location sound handle.
  SoundHandle? _locationSoundHandle;

  /// The server options to work with.
  ServerOptions? _serverOptions;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    index = 0;
    _lastLoaded = DateTime.now();
  }

  /// Play the location ping.
  Future<void> playLocationSound() async {
    final data = await client.users.getLocationSound();
    final SoundHandle soundHandle;
    await _locationSoundHandle?.stop();
    if (kIsWeb) {
      final soLoud = SoLoud.instance;
      final audioSource = await soLoud.loadMem(
        'location.wav',
        Uint8List.fromList(data),
      );
      soundHandle = await soLoud.play(audioSource)
        ..scheduleStop(audioSource.length);
    } else {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final appDocumentsDirectory = Directory(
        path.join(documentsDirectory.path, 'talking_noticeboard'),
      );
      if (!appDocumentsDirectory.existsSync()) {
        appDocumentsDirectory.createSync(recursive: true);
      }
      final file = File(path.join(appDocumentsDirectory.path, 'location.wav'))
        ..writeAsBytesSync(data);
      if (!mounted) {
        return;
      }
      soundHandle = await context.playSound(
        file.path.asSound(
          destroy: false,
          soundType: SoundType.file,
        ),
      );
    }
    if (context.mounted) {
      _locationSoundHandle = soundHandle;
    } else {
      await soundHandle.stop();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _noticeSoundHandle?.stop();
    _locationTimer?.cancel();
    _locationSoundHandle?.stop();
    _locationSoundHandle = null;
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
    final serverOptions = _serverOptions;
    if (serverOptions == null) {
      reloadServerOptions();
      return const LoadingScreen();
    }
    final notices = _notices;
    if (notices == null ||
        DateTime.now().difference(_lastLoaded) > widget.loadInterval) {
      reloadNotices();
      return const LoadingScreen();
    }
    final Widget child;
    if (notices.isEmpty) {
      _notices = null;
      child = Material(
        child: NoticeText(
          text: 'There are no notices to show.',
          serverOptions: serverOptions,
        ),
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
        child: NoticeText(
          text: notice.text,
          serverOptions: serverOptions,
        ),
      );
    }
    return GestureDetector(
      onTap: () => switchNotices(serverOptions),
      child: Focus(
        autofocus: true,
        onKeyEvent: (final node, final event) {
          if (widget.canPop && event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          }
          switchNotices(serverOptions);
          return KeyEventResult.handled;
        },
        child: child,
      ),
    );
  }

  /// Switch to the next notice.
  void switchNotices(final ServerOptions serverOptions) {
    final lastSkip = _lastSkip;
    final now = DateTime.now();
    if (lastSkip == null ||
        now.difference(lastSkip) > serverOptions.skipInterval) {
      setState(() {
        _lastSkip = now;
        index++;
      });
    }
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

  /// Reload both server options, and the notices.
  Future<void> reloadNotices() async {
    try {
      await reloadServerOptions();
      _notices = await client.notices.getNotices();
      _error = null;
      _stackTrace = null;
      resetTimes();
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      await handleError(e, s);
    }
  }

  /// Reload the server options.
  Future<void> reloadServerOptions() async {
    try {
      final serverOptions = await client.users.getServerOptions();
      _serverOptions = serverOptions;
      _locationTimer?.cancel();
      _locationTimer = Timer.periodic(
        serverOptions.playLocationInterval,
        (final _) => playLocationSound(),
      );
      setState(() {});
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      await handleError(e, s);
    }
  }
}
