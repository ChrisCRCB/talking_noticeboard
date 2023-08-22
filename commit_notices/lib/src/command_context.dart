/// A class to hold information about a [command].
class CommandContext {
  /// Create an instance.
  const CommandContext({
    required this.command,
    required this.arguments,
  });

  /// The command to run.
  final String command;

  /// The arguments to pass to [command].
  final List<String> arguments;
}
