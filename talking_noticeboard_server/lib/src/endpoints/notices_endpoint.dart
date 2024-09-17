import 'dart:io';

import 'package:path/path.dart' as path;
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

  /// Add a notice.
  Future<Notice> addNotice(
    final Session session, {
    required final String text,
    required final List<int> soundBytes,
  }) async {
    final userInfo = await session.requireScopes([addNotices]);
    if (!soundsDirectory.existsSync()) {
      soundsDirectory.createSync(recursive: true);
    }
    final notice = await Notice.db.insertRow(
      session,
      Notice(
        userInfoId: userInfo.id!,
        text: text,
      ),
    );
    final fullPath = path.join(soundsDirectory.path, notice.filename.uuid);
    File(fullPath).writeAsBytesSync(soundBytes);
    return notice;
  }

  /// Delete [notice].
  Future<void> deleteNotice(final Session session, final Notice notice) async {
    if (notice.id != null) {
      throw ErrorMessage(message: 'You cannot delete $notice without an ID.');
    }
    final fullPath = path.join(soundsDirectory.path, notice.filename.uuid);
    final file = File(fullPath);
    if (file.existsSync()) {
      file.deleteSync(recursive: true);
    }
    await Notice.db.deleteRow(session, notice);
  }

  /// List all notices.
  Future<List<Notice>> getNotices(final Session session) async {
    await _ensureAdmins(session);
    return Notice.db.find(session, orderBy: (final t) => t.createdAt);
  }

  /// Get the contents of a sound file.
  Future<List<int>> getSoundBytes(
    final Session session,
    final String filename,
  ) async {
    final fullPath = path.join(soundsDirectory.path, filename);
    return File(fullPath).readAsBytesSync();
  }
}
