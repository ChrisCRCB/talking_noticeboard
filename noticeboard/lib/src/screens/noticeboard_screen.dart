import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:noticeboard_backend/noticeboard_backend.dart';

import '../../constants.dart';
import '../providers/providers.dart';

/// The notices screen.
class NoticeboardScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const NoticeboardScreen({
    required this.baseUrl,
    super.key,
  });

  /// The base URL to use.
  final String baseUrl;

  /// Create state for this widget.
  @override
  NoticeboardScreenState createState() => NoticeboardScreenState();
}

/// State for [NoticeboardScreen].
class NoticeboardScreenState extends ConsumerState<NoticeboardScreen> {
  /// The timer for downloading notices.
  Timer? _downloadTimer;

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
    _audioPlayer = AudioPlayer(playerId: 'Noticeboard audio player');
    _notices = [];
    _tts = FlutterTts();
  }

  /// Dispose of things.
  @override
  void dispose() {
    super.dispose();
    _downloadTimer?.cancel();
    _audioPlayer.dispose();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final baseUrl = widget.baseUrl;
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
    final audioPath = notice.audioPath;
    if (audioPath != null) {
      _tts.stop();
      final url = '$baseUrl/audio/$audioPath/';
      _audioPlayer.play(UrlSource(url));
    } else {
      _audioPlayer.stop();
      _tts.speak(text);
    }
    return WillPopScope(
      onWillPop: () {
        maybeSetState();
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: maybeSetState,
        onDoubleTap: maybeSetState,
        onLongPress: maybeSetState,
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
    );
  }

  /// Download all notices.
  Future<void> downloadNotices({
    final bool callSetState = true,
  }) async {
    final baseUrl = widget.baseUrl;
    _downloadTimer?.cancel();
    _downloadTimer = null;
    final url = '$baseUrl/notices/';
    final dio = ref.watch(dioProvider);
    try {
      final response = await dio.get<Map<String, dynamic>>(url);
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
        downloadNotices,
      );
    } on DioException {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.remove(urlPreferencesKey);
      ref.invalidate(urlProvider);
    }
  }

  /// Maybe call [setState].
  void maybeSetState() {
    final now = DateTime.now();
    final lastSetState = _lastSetState;
    if (lastSetState == null || now.difference(lastSetState) >= tapInterval) {
      _lastSetState = now;
      setState(() {});
    }
  }
}
