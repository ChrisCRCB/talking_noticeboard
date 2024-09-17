/// A sound file to be uploaded.
class SoundFile {
  /// Create an instance.
  const SoundFile({required this.path, required this.bytes});

  /// The path to the file.
  final String path;

  /// The bytes of the file.
  final List<int> bytes;
}
