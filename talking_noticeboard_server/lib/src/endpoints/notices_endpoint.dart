import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import '../constants.dart';
import '../extensions.dart';
import '../generated/protocol.dart';

/// The endpoint for notices.
class NoticesEndpoint extends Endpoint {
  /// Whether or not admins have been checked for.
  bool adminCheck = false;

  /// Logins aren't strictly necessary.
  @override
  bool get requireLogin => false;

  /// Ensure there is at least 1 admin.
  Future<void> _ensureAdmins(final Session session) async {
    if (adminCheck) {
      return;
    }
    adminCheck = true;
    final users = await UserInfo.db.find(session);
    if (users.isNotEmpty &&
        users
            .where((final user) => user.scopes.contains(Scope.admin))
            .isEmpty) {
      for (final user in users) {
        session.log('Promoting ${user.userIdentifier} to admin.');
        await Users.updateUserScopes(
          session,
          user.id!,
          {...user.scopes, Scope.admin},
        );
      }
    }
  }

  /// Return `true` if [path] has been uploaded.
  Future<bool> verifyUpload(final Session session, final String path) async =>
      session.storage.verifyDirectFileUpload(
        storageId: noticeStorageId,
        path: path,
      );

  /// Create a new file upload description.
  Future<String?> createUploadDescription(
    final Session session,
    final String path,
  ) =>
      session.storage.createDirectFileUploadDescription(
        storageId: noticeStorageId,
        path: path,
      );

  /// Add a notice.
  Future<Notice> addNotice(
    final Session session, {
    required final String text,
    required final String path,
  }) async {
    final userInfo = await session.requireScopes([addNotices]);
    if (!(await session.storage
        .fileExists(storageId: noticeStorageId, path: path))) {
      throw ErrorMessage(message: 'You must first upload a sound file.');
    }
    final notice = await Notice.db.insertRow(
      session,
      Notice(
        userInfoId: userInfo.id!,
        text: text,
        path: path,
      ),
    );
    return notice.copyWith(userInfo: userInfo);
  }

  /// Delete [notice].
  Future<void> deleteNotice(final Session session, final Notice notice) async {
    await session.requireScopes([deleteNotices]);
    if (notice.id == null) {
      throw ErrorMessage(message: 'You cannot delete $notice without an ID.');
    }
    if (await session.storage
        .fileExists(storageId: noticeStorageId, path: notice.path)) {
      await session.storage.deleteFile(
        storageId: noticeStorageId,
        path: notice.path,
      );
    }
    await Notice.db.deleteRow(session, notice);
  }

  /// List all notices.
  Future<List<Notice>> getNotices(final Session session) async {
    await _ensureAdmins(session);
    return Notice.db.find(
      session,
      orderBy: (final t) => t.createdAt,
      include: Notice.include(userInfo: UserInfo.include()),
    );
  }

  /// Get the contents of a sound file.
  Future<ByteData> getSoundBytes(
    final Session session,
    final String path,
  ) async {
    if (await session.storage
        .fileExists(storageId: noticeStorageId, path: path)) {
      final bytes = await session.storage.retrieveFile(
        storageId: noticeStorageId,
        path: path,
      );
      return bytes!;
    }
    throw ErrorMessage(message: 'File does not exist: $path.');
  }
}
