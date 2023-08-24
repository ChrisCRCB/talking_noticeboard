import 'dart:async';

import 'package:backstreets_widgets/screens/simple_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';

import '../../constants.dart';
import '../providers/providers.dart';

/// A screen to set the server URL.
class UrlScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const UrlScreen({
    super.key,
  });

  /// Create state.
  @override
  UrlScreenState createState() => UrlScreenState();
}

/// State for [UrlScreen].
class UrlScreenState extends ConsumerState<UrlScreen> {
  /// The text controller to use for the URL field.
  late final TextEditingController urlController;

  /// The controller to use for the authorization field.
  late final TextEditingController authorizationController;

  /// The form key to use.
  late final GlobalKey<FormState> formKey;

  /// A timer to automatically connect.
  late final Timer? connectTimer;

  /// Initialise [urlController] and [formKey].
  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(
      text: const String.fromEnvironment('url'),
    );
    authorizationController = TextEditingController(
      text: const String.fromEnvironment('authorization'),
    );
    formKey = GlobalKey();
    if (urlController.text.isNotEmpty) {
      connectTimer = Timer(const Duration(seconds: 5), submitForm);
    } else {
      connectTimer = null;
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final controller in [urlController, authorizationController]) {
      controller.dispose();
    }
    connectTimer?.cancel();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SimpleScaffold(
        title: 'Server URL',
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                autofocus: true,
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Notices URL'),
                onFieldSubmitted: (final value) => submitForm(),
                validator: ValidationBuilder().url('Invalid URL').build(),
              ),
              TextFormField(
                controller: authorizationController,
                decoration: const InputDecoration(
                  labelText: 'Authorization String',
                ),
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  } else if (value.split(':').length != 2) {
                    return 'Must be written as username:password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: submitForm,
          tooltip: 'Save',
          child: const Icon(Icons.save_rounded),
        ),
      );

  /// Submit the form.
  Future<void> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setString(urlPreferencesKey, urlController.text);
      final authorizationString = authorizationController.text;
      if (authorizationString.isEmpty) {
        await prefs.remove(authorizationString);
      } else {
        await prefs.setString(authorizationPreferencesKey, authorizationString);
      }
      ref
        ..invalidate(urlProvider)
        ..invalidate(authorizationStringProvider);
    }
  }
}
