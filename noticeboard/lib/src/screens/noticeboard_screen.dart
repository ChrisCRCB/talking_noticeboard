import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noticeboard_backend/noticeboard_backend.dart';

import '../../constants.dart';
import '../../gen/assets.gen.dart';
import '../providers/providers.dart';

/// The random number generator to use.
final random = Random();

/// The notices screen.
class NoticeboardScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const NoticeboardScreen({
    required this.baseUrl,
    required this.authorizationString,
    super.key,
  });

  /// The base URL to use.
  final String baseUrl;

  /// The authorization string to use.
  final String? authorizationString;

  /// Create state for this widget.
  @override
  NoticeboardScreenState createState() => NoticeboardScreenState();
}

/// State for [NoticeboardScreen].
class NoticeboardScreenState extends ConsumerState<NoticeboardScreen> {
  /// The timer for downloading notices.
  Timer? _downloadTimer;

  /// The timer for playing instructions.
  late Timer _instructionsTimer;

  /// The audio player to use.
  late final AudioPlayer _audioPlayer;

  /// The unread notices.
  late final List<Notice> _notices;

  /// The last time [setState] was called.
  DateTime? _lastSetState;

  /// The TTS instance to use.
  late final FlutterTts _tts;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _notices = [];
    _tts = FlutterTts();
    startInstructionsTimer(cancelFirst: false);
  }

  /// Dispose of things.
  @override
  void dispose() {
    super.dispose();
    _downloadTimer?.cancel();
    _audioPlayer.dispose();
    _instructionsTimer.cancel();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final notices = _notices;
    if (notices.isEmpty) {
      downloadNotices();
      notices.add(const Notice(text: 'Loading...', audioPath: null));
    }
    final notice = notices.removeAt(0);
    if (notices.isEmpty) {
      downloadNotices(callSetState: false);
    }
    final text = notice.text ?? 'This notice has no text.';
    playOrSpeak(
      text: text,
      audioPath: notice.audioPath,
    );
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.keyR): maybeSetState},
      child: WillPopScope(
        onWillPop: () {
          maybeSetState();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: maybeSetState,
          onDoubleTap: maybeSetState,
          onLongPress: maybeSetState,
          onHorizontalDragStart: (final details) => maybeSetState(),
          child: Semantics(
            liveRegion: true,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns an authorization header, if required.
  String? getAuthorizationHeader() {
    final authorizationString = widget.authorizationString;
    final authorizationBytes =
        authorizationString == null ? null : utf8.encode(authorizationString);
    if (authorizationBytes == null) {
      return null;
    }
    return 'Basic ${base64Encode(authorizationBytes)}';
  }

  /// Get all headers.
  Map<String, String> getHeaders() {
    final authorizationHeader = getAuthorizationHeader();
    return {
      // Skip ngrok's browser warning.
      'ngrok-skip-browser-warning': 'true',
      if (authorizationHeader != null) 'Authorization': authorizationHeader,
    };
  }

  /// Download all notices.
  Future<void> downloadNotices({
    final bool callSetState = true,
  }) async {
    final baseUrl = widget.baseUrl;
    _downloadTimer?.cancel();
    _downloadTimer = null;
    final url = '$baseUrl/notices.json';
    final dio = ref.watch(dioProvider);
    startInstructionsTimer();
    try {
      final response = await dio.get<Map<String, dynamic>>(
        url,
        options: Options(
          headers: getHeaders(),
        ),
      );
      final data = response.data;
      _notices.clear();
      if (data != null) {
        _notices.addAll(Notices.fromJson(data).notices);
      } else {
        _notices.add(
          const Notice(
            text: 'There was an error downloading notices.',
            audioPath: null,
          ),
        );
      }
      if (callSetState) {
        setState(() {});
      }
      _downloadTimer = Timer(
        const Duration(minutes: 15),
        () => downloadNotices(callSetState: false),
      );
    } on DioException {
      if (mounted) {
        final prefs = await ref.read(sharedPreferencesProvider.future);
        await prefs.remove(urlPreferencesKey);
        await prefs.remove(authorizationPreferencesKey);
        ref.invalidate(urlProvider);
      }
      rethrow;
    }
  }

  /// Maybe call [setState].
  void maybeSetState() {
    final now = DateTime.now();
    final lastSetState = _lastSetState;
    if (lastSetState == null || now.difference(lastSetState) >= tapInterval) {
      _lastSetState = now;
      startInstructionsTimer();
      setState(() {});
    }
  }

  /// Start the instructions timer.
  void startInstructionsTimer({
    final bool cancelFirst = true,
  }) {
    if (cancelFirst) {
      _instructionsTimer.cancel();
    }
    _instructionsTimer = Timer.periodic(
      const Duration(minutes: 15),
      (final timer) async {
        final assets = Assets.instructions.values;
        final asset = assets[random.nextInt(assets.length)];
        await _audioPlayer.setAsset(asset);
        if (mounted) {
          await _audioPlayer.play();
        }
      },
    );
  }

  /// Either play [audioPath], or speak [text].
  Future<void> playOrSpeak({
    required final String text,
    required final String? audioPath,
  }) async {
    if (audioPath != null) {
      final url = '${widget.baseUrl}/$audioPath';
      try {
        await _audioPlayer.setUrl(
          url,
          headers: getHeaders(),
        );
        await _tts.stop();
        await _audioPlayer.play();
      } on PlayerException {
        await _audioPlayer.stop();
        await _tts.speak(text);
      }
    } else {
      await _audioPlayer.stop();
      await _tts.speak(text);
    }
  }
}
