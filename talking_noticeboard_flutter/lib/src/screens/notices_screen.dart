import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';
import '../widgets/custom_text.dart';
import 'account_screen.dart';
import 'create_notice_screen.dart';
import 'noticeboard.dart';
import 'server_options_screen.dart';
import 'update_user_screen.dart';

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
        leading: TextButton(
          onPressed: () => context.pushWidgetBuilder(
            (final _) => const Noticeboard(
              canPop: true,
            ),
          ),
          child: const CustomText('Noticeboard'),
        ),
        actions: [
          IconButton(
            onPressed: updateUser,
            icon: const Icon(
              Icons.edit,
              semanticLabel: 'Edit Users',
            ),
          ),
          refreshButton,
          IconButton(
            onPressed: () async {
              final serverOptions = await client.users.getServerOptions();
              if (context.mounted) {
                await context.pushWidgetBuilder(
                  (final _) =>
                      ServerOptionsScreen(serverOptions: serverOptions),
                );
              }
            },
            icon: const Icon(
              Icons.settings,
              semanticLabel: 'ServerOptions',
            ),
          ),
        ],
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
                    return CommonShortcuts(
                      deleteCallback: () => deleteNotice(notice),
                      child: PlaySoundSemantics(
                        sound: notice.path.asSound(
                          destroy: false,
                          soundType: SoundType.custom,
                        ),
                        child: ListTile(
                          autofocus: true,
                          title: Text(
                            notice.userInfo?.userIdentifier ?? 'Unknown',
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            notice.text,
                            style: const TextStyle(fontSize: 20),
                          ),
                          onTap: () => deleteNotice(notice),
                        ),
                      ),
                    );
                  },
                  itemCount: notices.length,
                ),
          onRefresh: () async {
            try {
              await client.notices.getNotices();
              _error = null;
              _stackTrace = null;
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
        SingleActivator(
          LogicalKeyboardKey.keyU,
          control: useControlKey,
          meta: useMetaKey,
        ): updateUser,
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

  /// Update a user.
  Future<void> updateUser() async =>
      context.pushWidgetBuilder((final _) => const UpdateUserScreen());

  /// Delete [notice].
  Future<void> deleteNotice(final Notice notice) => confirm(
        context: context,
        message: 'Really delete this notice?',
        title: 'Delete Notice',
        yesCallback: () async {
          Navigator.pop(context);
          try {
            await client.notices.deleteNotice(notice);
            setState(() {
              _notices = null;
            });
            // ignore: avoid_catches_without_on_clauses
          } catch (e, s) {
            handleError(e, s);
          }
        },
      );
}
