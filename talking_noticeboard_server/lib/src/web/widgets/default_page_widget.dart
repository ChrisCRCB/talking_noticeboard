import 'package:serverpod/serverpod.dart';

/// The default page.
class DefaultPageWidget extends Widget {
  /// Create an instance.
  DefaultPageWidget() : super(name: 'default') {
    values = {
      'served': DateTime.now(),
      'runmode': Serverpod.instance.runMode,
    };
  }
}
