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
  /// The text controller to use.
  late final TextEditingController controller;

  /// The form key to use.
  late final GlobalKey<FormState> formKey;

  /// Initialise [controller] and [formKey].
  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: const String.fromEnvironment('url'));
    formKey = GlobalKey();
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
                controller: controller,
                decoration: const InputDecoration(labelText: 'Notices URL'),
                onFieldSubmitted: (final value) => submitForm(),
                validator: ValidationBuilder().url('Invalid URL').build(),
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
      await prefs.setString(urlPreferencesKey, controller.text);
      ref.invalidate(urlProvider);
    }
  }
}
