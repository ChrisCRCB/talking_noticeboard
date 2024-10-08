import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import '../constants.dart';
import '../extensions.dart';
import '../generated/protocol.dart';

/// The endpoint for user management.
class UsersEndpoint extends Endpoint {
  /// Get the scopes for a user with the given [email].
  Future<List<String>?> getScopeNames(
    final Session session,
    final String email,
  ) async {
    await session.requireScopes([Scope.admin.name!]);
    final user = await Users.findUserByEmail(session, email);
    return user?.scopeNames;
  }

  /// Returns all the possible scopes for this server.
  Future<List<String>> getScopes(final Session session) async {
    final adminScope = Scope.admin.name!;
    await session.requireScopes([adminScope]);
    return [
      downloadNotices,
      adminScope,
      addNotices,
      deleteNotices,
      editServerOptions,
    ];
  }

  /// Update {scopes} for the user with the given [email] address.
  Future<bool> updateScopes(
    final Session session,
    final String email,
    final List<String> scopes,
  ) async {
    await session.requireScopes([Scope.admin.name!]);
    final user = await Users.findUserByEmail(session, email);
    if (user == null) {
      return false;
    }
    await Users.updateUserScopes(
      session,
      user.id!,
      scopes.map(Scope.new).toSet(),
    );
    return true;
  }

  /// Get the server options.
  Future<ServerOptions> getServerOptions(final Session session) async =>
      session.serverOptions;

  /// Update server options.
  Future<void> updateServerOptions(
    final Session session,
    final ServerOptions serverOptions,
  ) async {
    await session.requireScopes([editServerOptions]);
    serverOptions.save();
  }

  /// Get the location sound.
  Future<List<int>> getLocationSound(final Session session) async {
    if (!soundsDirectory.existsSync()) {
      soundsDirectory.createSync(recursive: true);
    }
    final file = File(
      path.join(
        soundsDirectory.path,
        session.serverOptions.locationSoundFilename,
      ),
    );
    if (file.existsSync()) {
      return file.readAsBytesSync();
    }
    throw ErrorMessage(message: 'File ${file.path} not found.');
  }
}
