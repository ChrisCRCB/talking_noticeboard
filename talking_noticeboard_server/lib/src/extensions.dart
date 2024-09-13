import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import 'generated/protocol.dart';

/// Useful extension methods.
extension SessionX on Session {
  /// Returns the user info attached to this session.
  ///
  /// If the user is not authenticated, then `null` will be returned.
  Future<UserInfo?> get userInfo async {
    final auth = await authenticated;
    if (auth == null) {
      return null;
    }
    final id = auth.userId;
    return Users.findUserByUserId(this, id);
  }

  /// Ensure a suitably authenticated user.
  Future<UserInfo> get requireUser async {
    final info = await userInfo;
    if (info == null) {
      throw ErrorMessage(message: 'You are not authenticated.');
    }
    return info;
  }

  /// Throws a message if this [Session] doesn't have the required [scopes].
  Future<UserInfo> requireScopes(final Iterable<String> scopes) async {
    final userInfo = await requireUser;
    for (final scope in scopes) {
      if (!userInfo.scopeNames.contains(scope)) {
        throw ErrorMessage(message: 'You do not have the $scope scope.');
      }
    }
    return userInfo;
  }
}
