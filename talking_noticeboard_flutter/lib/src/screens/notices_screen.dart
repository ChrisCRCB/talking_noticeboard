import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';
import 'account_screen.dart';
import 'create_notice_screen.dart';

/// A [ListView] which shows notices.
class NoticesScreen extends StatefulWidget {
  /// Create an instance.
  const NoticesScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  NoticesScreenState createState() => NoticesScreenState();
}

/// State for [NoticesScreen].
class NoticesScreenState extends State<NoticesScreen> {
  /// An error object.
  Object? _error;

  /// A stack trace.
  StackTrace? _stackTrace;

  /// The currently-loaded notices.
  List<Notice>? _notices;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    sessionManager.addListener(() => setState(() {}));
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    if (!sessionManager.isSignedIn) {
      return const AccountScreen();
    }
    final refreshButton = IconButton(
      onPressed: performRefresh,
      icon: const Icon(Icons.refresh),
      tooltip: 'Refresh',
    );
    final notices = _notices;
    if (notices == null) {
      client.notices
          .getNotices()
          .then(
            (final value) => setState(() {
              _error = null;
              _stackTrace = null;
              _notices = value;
            }),
          )
          .onError(handleError);
      return const LoadingScreen();
    }
    final Widget child;
    final error = _error;
    if (error != null) {
      child = SimpleScaffold(
        actions: [refreshButton],
        title: 'Error',
        body: ErrorListView(
          error: error,
          stackTrace: _stackTrace,
        ),
      );
    } else {
      child = SimpleScaffold(
        actions: [refreshButton],
        title: 'Notices',
        body: RefreshIndicator(
          child: notices.isEmpty
              ? const CenterText(
                  text: 'There are no notices to show.',
                  autofocus: true,
                )
              : ListViewBuilder(
                  itemBuilder: (final context, final index) {
                    final notice = notices[index];
                    return ListTile(
                      autofocus: true,
                      title: Text(
                        notice.userInfo?.userIdentifier ?? 'Unknown',
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        notice.text,
                        style: const TextStyle(fontSize: 20),
                      ),
                      onTap: () {},
                    );
                  },
                  itemCount: notices.length,
                ),
          onRefresh: () async {
            try {
              final result = await client.notices.getNotices();
              _error = null;
              _stackTrace = null;
              setState(() => _notices = result);
              // ignore: avoid_catches_without_on_clauses
            } catch (e, s) {
              handleError(e, s);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: newNotice,
          tooltip: 'New notice',
          child: const Icon(Icons.add),
        ),
      );
    }
    return CallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.keyR,
          control: useControlKey,
          meta: useMetaKey,
        ): performRefresh,
        SingleActivator(
          LogicalKeyboardKey.keyN,
          control: useControlKey,
          meta: useMetaKey,
        ): newNotice,
      },
      child: child,
    );
  }

  /// Perform a refresh.
  void performRefresh() {
    _notices = null;
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  /// Handle an error.
  void handleError(final Object error, final StackTrace stackTrace) =>
      setState(() {
        _error = error;
        _stackTrace = stackTrace;
      });

  /// Create a new notice.
  void newNotice() => context.pushWidgetBuilder(
        (final _) => CreateNoticeScreen(
          onDone: (final notice) {
            _notices ??= [];
            _notices!.add(notice);
            setState(() {});
          },
        ),
      );
}
