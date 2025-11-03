import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:stts/stts.dart';

import '../../gen/assets.gen.dart';
import '../constants.dart';
import '../json/notice.dart';
import '../widgets/notice_text.dart';

/// The home page.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({
    required this.noticesDirectory,
    this.noticeSkipInterval = const Duration(seconds: 5),
    this.locationSoundDelay = const Duration(minutes: 10),
    super.key,
  });

  /// The directory where notices will be loaded from.
  final Directory noticesDirectory;

  /// How often the notices can be skipped.
  final Duration noticeSkipInterval;

  /// How often the location ping should play.
  final Duration locationSoundDelay;

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// The TTS system to use.
  late final Tts tts;

  /// The timer for playing location sounds.
  late final Timer _locationTimer;

  /// The index of the current notice.
  late int noticeIndex;

  /// The sound handle of the currently-playing sound.
  late final AudioPlayer _audioPlayer;

  /// The time the notices were last skipped.
  late DateTime lastSkipped;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    tts = Tts();
    _audioPlayer = AudioPlayer();
    _locationTimer = Timer.periodic(widget.locationSoundDelay, (final timer) {
      if (context.mounted) {
        if (_audioPlayer.state != PlayerState.playing) {
          _audioPlayer.play(AssetSource(Assets.sounds.location));
        }
      } else {
        timer.cancel();
      }
    });
    noticeIndex = 0;
    lastSkipped = DateTime.now();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    tts.stop();
    _locationTimer.cancel();
    _audioPlayer.dispose();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    Notice notice;
    try {
      final notices = widget.noticesDirectory
          .listSync()
          .whereType<Directory>()
          .where((final subdirectory) => subdirectory.listSync().isNotEmpty)
          .map((final subdirectory) {
            final files = subdirectory.listSync().whereType<File>().toList();
            String text;
            try {
              final file = files.firstWhere(
                (final file) => path.extension(file.path) == '.txt',
              );
              text = file.readAsStringSync();
              // ignore: avoid_catching_errors
            } on StateError {
              text =
                  // ignore: lines_longer_than_80_chars
                  'No file found. Make sure your notice is created in notepad, and the file is stored with a .txt extension.';
            }
            String? soundFilePath;
            try {
              final soundFile = files.firstWhere(
                (final file) =>
                    audioFileExtensions.contains(path.extension(file.path)),
              );
              soundFilePath = soundFile.path;
              // ignore: avoid_catching_errors
            } on StateError {
              // soundFilePath = null;
            }
            return Notice(text: text, soundPath: soundFilePath);
          })
          .toList();
      if (notices.isEmpty) {
        notice = const Notice(text: 'There are no notices to display.');
      } else {
        if (noticeIndex >= notices.length) {
          noticeIndex = 0;
        }
        notice = notices[noticeIndex];
        final soundPath = notice.soundPath;
        if (soundPath == null) {
          speak(notice.text);
        } else {
          playNoticeSound(soundPath);
        }
      }
    } on FileSystemException {
      notice = Notice(
        text:
            'No notices could be loaded from ${widget.noticesDirectory.path}.',
      );
      speak(notice.text);
      _audioPlayer.play(AssetSource(Assets.sounds.error));
    }
    return Material(
      color: Colors.black,
      child: Focus(
        autofocus: true,
        onKeyEvent: (final node, final event) {
          final now = DateTime.now();
          if (now.difference(lastSkipped) > widget.noticeSkipInterval) {
            lastSkipped = now;
            noticeIndex++;
            final month = now.month.toString().padLeft(2, '0');
            final day = now.day.toString().padLeft(2, '0');
            final directory = Directory(
              path.join(
                widget.noticesDirectory.parent.path,
                telemetryDirectoryName,
              ),
            );
            final file = File(
              path.join(
                directory.path,
                '${now.year}-$month-$day - $telemetryFilename',
              ),
            );
            try {
              if (!directory.existsSync()) {
                directory.createSync(recursive: true);
              }
              final string = '${now.toIso8601String()}\n';
              if (file.existsSync()) {
                file.openSync(mode: FileMode.append)
                  ..writeStringSync(string)
                  ..flushSync()
                  ..closeSync();
              } else {
                file.writeAsStringSync(string);
              }
              // ignore: avoid_catches_without_on_clauses
            } catch (_) {
              // Do nothing.
            }
            setState(() {});
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 400,
            color: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: NoticeText(text: notice.text),
        ),
      ),
    );
  }

  /// Speak some [text].
  Future<void> speak(final String text) async {
    await tts.stop();
    await tts.start(text);
  }

  /// Play the notice sound from [soundPath].
  Future<void> playNoticeSound(final String soundPath) async {
    unawaited(tts.stop());
    try {
      await _audioPlayer.play(DeviceFileSource(soundPath));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (mounted) {
        await _audioPlayer.play(AssetSource(Assets.sounds.error));
      }
    }
  }
}
