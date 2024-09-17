import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as path;
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';
import '../sound_file.dart';
import '../widgets/custom_text.dart';

/// The UUID generator to use.
const uuid = Uuid();

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

  /// The sound file to upload.
  SoundFile? _soundFile;

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
                final soundFile = _soundFile;
                if (soundFile == null) {
                  return showMessage(
                    context: context,
                    message: 'You must choose a sound file.',
                  );
                }
                try {
                  final uploadDescription =
                      await client.notices.createUploadDescription(
                    soundFile.path,
                  );
                  if (uploadDescription == null) {
                    if (context.mounted) {
                      await showMessage(
                        context: context,
                        message: 'Failed to create file.',
                      );
                    }
                    return;
                  }
                  final uploader = FileUploader(uploadDescription);
                  final result = await uploader.upload(
                    Stream.fromIterable([soundFile.bytes]),
                    soundFile.bytes.length,
                  );
                  if (!result) {
                    if (context.mounted) {
                      await showMessage(
                        context: context,
                        message: 'Failed to upload file.',
                      );
                    }
                  }
                  final notice = await client.notices.addNotice(
                    text: noticeTextController.text,
                    path: soundFile.path,
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
                  // ignore: avoid_catches_without_on_clauses
                } catch (e, s) {
                  if (context.mounted) {
                    await showMessage(context: context, message: '$e\n$s');
                  }
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
                    final filePath = file.name;
                    final List<int> bytes;
                    final extension = path.extension(filePath);
                    final uploadPath = '${uuid.v4()}$extension';
                    if (file.bytes == null) {
                      bytes = File(filePath).readAsBytesSync();
                    } else {
                      bytes = file.bytes!;
                    }
                    setState(() {
                      _soundFile = SoundFile(path: uploadPath, bytes: bytes);
                    });
                  },
                  child: CustomText(
                    _soundFile == null ? 'Set sound file' : 'Change sound file',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
