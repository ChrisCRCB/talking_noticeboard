import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import '../constants.dart';
import '../extensions.dart';
import '../generated/protocol.dart';

/// The endpoint for user management.
class UsersEndpoint extends Endpoint {
  /// Require login.
  @override
  bool get requireLogin => true;

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
    return [adminScope, addNotices, deleteNotices, editServerOptions];
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
}
