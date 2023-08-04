import 'dart:io';

/// A class which represents an [event] and it's associated [timestamp].
class DatedFileSystemEvent {
  /// Create an instance.
  const DatedFileSystemEvent({
    required this.event,
    required this.timestamp,
  });

  /// The event that was emitted.
  final FileSystemEvent event;

  /// The time that [event] was emitted.
  final DateTime timestamp;
}
