import 'dart:io';

/// The scope for adding notices.
const String addNotices = 'add-notice';

/// The scope required for deleting notices.
const String deleteNotices = 'delete-notice';

/// Scope for editing server options.
const editServerOptions = 'edit-server-options';

/// The storage key for notice sound files.
const noticeStorageId = 'public';

/// The file where server options reside.
final serverOptionsFile = File('config/server_options.json');

/// The directory where sound files are stored.
final soundsDirectory = Directory('sounds');
