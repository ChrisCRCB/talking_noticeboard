import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';

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

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final refreshButton = IconButton(
      onPressed: () => setState(() {
        _error = null;
        _stackTrace = null;
        _notices = null;
      }),
      icon: const Icon(Icons.refresh),
      tooltip: 'Refresh',
    );
    final error = _error;
    if (error != null) {
      return SimpleScaffold(
        actions: [refreshButton],
        title: 'Error',
        body: ErrorListView(
          error: error,
          stackTrace: _stackTrace,
        ),
      );
    }
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
    return SimpleScaffold(
      actions: [refreshButton],
      title: 'Notices',
      body: ListViewBuilder(
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
    );
  }

  /// Handle an error.
  void handleError(final Object error, final StackTrace stackTrace) =>
      setState(() {
        _error = error;
        _stackTrace = stackTrace;
      });
}
