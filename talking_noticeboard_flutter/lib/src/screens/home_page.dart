import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

import '../client.dart';
import 'notices_screen.dart';

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// Whether the [sessionManager] has been initialised yet.
  late bool _sessionManagerInitialised;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _sessionManagerInitialised = false;
    sessionManager.addListener(() => setState(() {}));
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    if (!_sessionManagerInitialised) {
      sessionManager
          .initialize()
          .then((final _) => setState(() => _sessionManagerInitialised = true));
      return const LoadingScreen();
    }
    if (sessionManager.isSignedIn) {
      return const NoticesScreen();
    }
    return SimpleScaffold(
      title: 'Login',
      body: Column(
        children: [
          const CenterText(
            text: 'You must login first.',
            autofocus: true,
            textStyle: TextStyle(fontSize: 20.0),
          ),
          SignInWithEmailButton(
            caller: client.modules.auth,
          ),
        ],
      ),
    );
  }
}
