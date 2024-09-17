import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import '../client.dart';
import '../widgets/custom_text.dart';

enum _Page {
  /// Account creation or authentication.
  account,

  /// Account verification.
  accountVerification,

  /// Password reset.
  passwordReset,
}

/// A screen for authenticating with a server via [client].
class AccountScreen extends StatefulWidget {
  /// Create an instance.
  const AccountScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  AccountScreenState createState() => AccountScreenState();
}

/// State for [AccountScreen].
class AccountScreenState extends State<AccountScreen> {
  /// The email endpoint.
  EndpointEmail get email => client.modules.auth.email;

  /// Errors.
  Object? _error;

  /// Stack trace.
  StackTrace? _stackTrace;

  /// The state of this page.
  late _Page _page;

  /// The form key to use.
  late final GlobalKey<FormState> _formKey;

  /// The username controller to use.
  late final TextEditingController _emailController;

  /// The password controller to use.
  late final TextEditingController _passwordController;

  /// The controller to use for verification codes.
  late final TextEditingController _verificationCodeController;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _page = _Page.account;
    _formKey = GlobalKey();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _verificationCodeController = TextEditingController();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return Cancel(
        child: ErrorScreen(
          error: error,
          stackTrace: _stackTrace,
        ),
      );
    }
    final page = _page;
    return Cancel(
      child: SimpleScaffold(
        title: 'Account Screen',
        body: Form(
          key: _formKey,
          child: Column(
            children: switch (page) {
              _Page.account => [
                  TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      label: CustomText('Email address'),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: CustomText('Password'),
                    ),
                    obscureText: true,
                    onFieldSubmitted: (final _) => performLogin(),
                    validator: FormBuilderValidators.password(),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            return;
                          }
                          try {
                            final response = await email.initiatePasswordReset(
                              _emailController.text,
                            );
                            if (!context.mounted) {
                              return;
                            }
                            if (response) {
                              _passwordController.text = '';
                              _setPage(_Page.passwordReset);
                            } else {
                              await showMessage(
                                context: context,
                                message:
                                    'That email address was not found on the '
                                    'system.',
                              );
                            }
                            // ignore: avoid_catches_without_on_clauses
                          } catch (e, s) {
                            _showError(e, s);
                          }
                        },
                        child: const Text('I forgot my password'),
                      ),
                      ElevatedButton(
                        onPressed: performLogin,
                        child: const Icon(
                          Icons.login,
                          semanticLabel: 'Login',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_isValid()) {
                            return;
                          }
                          final emailAddress = _emailController.text;
                          final password = _passwordController.text;
                          try {
                            final response = await email.createAccountRequest(
                              emailAddress,
                              emailAddress,
                              password,
                            );
                            if (!context.mounted) {
                              return;
                            }
                            if (response) {
                              _setPage(_Page.accountVerification);
                            } else {
                              await showMessage(
                                context: context,
                                message:
                                    'That account has already been created.',
                              );
                            }
                            // ignore: avoid_catches_without_on_clauses
                          } catch (e, s) {
                            _showError(e, s);
                          }
                        },
                        child: const Text('Create account'),
                      ),
                    ],
                  ),
                ],
              _Page.accountVerification => [
                  TextFormField(
                    autofocus: true,
                    controller: _verificationCodeController,
                    decoration: const InputDecoration(
                      label: CustomText('Verification code sent to your email'),
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isValid()) {
                        return;
                      }
                      try {
                        final userInfo = await email.createAccount(
                          _emailController.text,
                          _verificationCodeController.text,
                        );
                        if (!context.mounted) {
                          return;
                        }
                        if (userInfo == null) {
                          await showMessage(
                            context: context,
                            message: 'Invalid verification code.',
                          );
                        } else {
                          _setPage(_Page.account);
                        }
                        // ignore: avoid_catches_without_on_clauses
                      } catch (e, s) {
                        _showError(e, s);
                      }
                    },
                    child: const Text('Verify account'),
                  ),
                ],
              _Page.passwordReset => [
                  TextFormField(
                    autofocus: true,
                    controller: _verificationCodeController,
                    decoration: const InputDecoration(
                      label: CustomText(
                        'Password verification code sent to your email',
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: CustomText('New password'),
                    ),
                    validator: FormBuilderValidators.password(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final result = await email.resetPassword(
                          _verificationCodeController.text,
                          _passwordController.text,
                        );
                        if (!context.mounted) {
                          return;
                        }
                        if (result) {
                          _setPage(_Page.account);
                        } else {
                          await showMessage(
                            context: context,
                            message: 'Failed to reset password.',
                          );
                        }
                        // ignore: avoid_catches_without_on_clauses
                      } catch (e, s) {
                        _showError(e, s);
                      }
                    },
                    child: const Text('Reset password'),
                  ),
                ],
            },
          ),
        ),
      ),
    );
  }

  /// Use [setState] to show an error [e] and stack trace [s].
  void _showError(final Object e, final StackTrace s) {
    setState(() {
      _error = e;
      _stackTrace = s;
    });
  }

  /// Set the page.
  void _setPage(final _Page page) => setState(() {
        _page = page;
      });

  /// Returns `true` if the form is successfully validated.
  bool _isValid() => _formKey.currentState?.validate() ?? false;

  /// Perform login.
  Future<void> performLogin() async {
    if (!_isValid()) {
      return;
    }
    // Code copied from `serverpod_auth_email_flutter`.
    final emailAddress = _emailController.text;
    final password = _passwordController.text;
    try {
      final response = await email.authenticate(
        emailAddress,
        password,
      );
      if (!response.success ||
          response.userInfo == null ||
          response.keyId == null ||
          response.key == null) {
        if (mounted) {
          await showMessage(
            context: context,
            message: 'Failed to authenticate: '
                '${response.failReason}.',
          );
        }
        return;
      }

      // Authentication was successful, store the key.
      final sessionManager = await SessionManager.instance;
      await sessionManager.registerSignedInUser(
        response.userInfo!,
        response.keyId!,
        response.key!,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      _showError(e, s);
    }
  }
}
