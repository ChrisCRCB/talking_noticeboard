import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../client.dart';
import '../widgets/custom_text.dart';

/// A screen for editing users.
class UpdateUserScreen extends StatefulWidget {
  /// Create an instance.
  const UpdateUserScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  UpdateUserScreenState createState() => UpdateUserScreenState();
}

/// State for [UpdateUserScreen].
class UpdateUserScreenState extends State<UpdateUserScreen> {
  /// An error object.
  Object? _error;

  /// A stack trace.
  StackTrace? _stackTrace;

  /// The email address to edit.
  late String email;

  /// The possible scope names.
  List<String>? _possibleScopeNames;

  /// The scope names for the user to be worked on.
  List<String>? _userScopeNames;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    email = '';
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return Cancel(
        child: ErrorScreen(
          error: error,
          stackTrace: _stackTrace,
        ),
      );
    }
    final possibleScopeNames = _possibleScopeNames;
    if (possibleScopeNames == null) {
      client.users
          .getScopes()
          .then(
            (final scopeNames) => setState(() {
              _error = null;
              _stackTrace = null;
              _possibleScopeNames = scopeNames;
            }),
          )
          .onError(handleError);
      return const LoadingScreen();
    }
    if (email.isEmpty) {
      return SimpleScaffold(
        title: 'Select User',
        body: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                label: CustomText('Email address'),
              ),
              onChanged: (final value) => email = value,
              onSubmitted: (final _) => setState(() {}),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() {}),
                  child: const CustomText('OK'),
                ),
              ],
            ),
          ],
        ),
      );
    }
    final userScopeNames = _userScopeNames;
    if (userScopeNames == null) {
      client.users
          .getScopeNames(email)
          .then(
            (final value) => setState(() {
              _error = null;
              _stackTrace = null;
              if (value == null) {
                email = '';
                if (context.mounted) {
                  showMessage(
                    context: context,
                    message: 'There is no account with that email address.',
                  );
                }
              } else {
                _userScopeNames = value;
              }
            }),
          )
          .onError(handleError);
      return const LoadingScreen();
    }
    return Cancel(
      child: SimpleScaffold(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await client.users.updateScopes(email, userScopeNames);
                if (context.mounted) {
                  Navigator.pop(context);
                }
                // ignore: avoid_catches_without_on_clauses
              } catch (e, s) {
                handleError(e, s);
              }
            },
            icon: const Icon(
              Icons.save,
              semanticLabel: 'Save',
            ),
          ),
        ],
        title: 'Edit Scopes',
        body: ListViewBuilder(
          itemBuilder: (final context, final index) {
            final scopeName = possibleScopeNames[index];
            return CheckboxListTile(
              autofocus: index == 0,
              value: userScopeNames.contains(scopeName),
              onChanged: (final value) {
                if (userScopeNames.contains(scopeName)) {
                  userScopeNames.remove(scopeName);
                } else {
                  userScopeNames.add(scopeName);
                }
                setState(() {});
              },
              title: CustomText(scopeName),
            );
          },
          itemCount: possibleScopeNames.length,
        ),
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
