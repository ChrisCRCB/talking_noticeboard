import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';
import '../widgets/custom_text.dart';

/// A screen for adding a new notice.
class CreateNoticeScreen extends StatefulWidget {
  /// Create an instance.
  const CreateNoticeScreen({
    required this.onDone,
    super.key,
  });

  /// The function to call when a new notice is created.
  final void Function(Notice notice) onDone;

  /// Create state for this widget.
  @override
  CreateNoticeScreenState createState() => CreateNoticeScreenState();
}

/// State for [CreateNoticeScreen].
class CreateNoticeScreenState extends State<CreateNoticeScreen> {
  /// The form key to use.
  late final GlobalKey<FormState> formKey;

  /// The controller for the notice text.
  late final TextEditingController noticeTextController;

  /// The bytes of a loaded sound.
  List<int>? soundFileBytes;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
    noticeTextController = TextEditingController();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    noticeTextController.dispose();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                final bytes = soundFileBytes;
                if (bytes == null || bytes.isEmpty) {
                  return showMessage(
                    context: context,
                    message: 'You must choose a sound file.',
                  );
                }
                try {
                  final notice = await client.notices.addNotice(
                    text: noticeTextController.text,
                    soundBytes: bytes,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  widget.onDone(notice);
                } on ErrorMessage catch (e) {
                  if (context.mounted) {
                    await showMessage(context: context, message: e.message);
                  }
                  return;
                }
              },
              child: const Icon(
                Icons.save,
                semanticLabel: 'Save',
              ),
            ),
          ],
          title: 'Create Notice',
          body: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: noticeTextController,
                  decoration: const InputDecoration(
                    label: CustomText('Notice text'),
                  ),
                  validator: FormBuilderValidators.minWordsCount(3),
                ),
                TextButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      dialogTitle: 'Choose Sound File',
                      type: FileType.audio,
                    );
                    if (result == null || result.files.isEmpty) {
                      return;
                    }
                    final file = result.files.single;
                    final path = file.path;
                    final List<int> bytes;
                    if (path != null) {
                      bytes = File(path).readAsBytesSync();
                    } else if (file.bytes != null) {
                      bytes = file.bytes!;
                    } else {
                      if (context.mounted) {
                        await showMessage(
                          context: context,
                          message: 'Could not load the file.',
                        );
                      }
                      return;
                    }
                    setState(() {
                      soundFileBytes = bytes;
                    });
                  },
                  child: CustomText(
                    soundFileBytes == null
                        ? 'Set sound file'
                        : 'Change sound file',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
