import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

/// Get a suitable SMTP server for sending emails.
SmtpServer getSmtpSever(final Session session) => SmtpServer(
      session.passwords['smtpServer']!,
      password: session.passwords['smtpPassword'],
      port: int.parse(session.passwords['smtpPort'] ?? '25'),
      ssl: bool.parse(session.passwords['smtpSsl'] ?? 'true'),
      username: session.passwords['smtpUsername'],
      name: session.passwords['emailFromName'],
    );

/// Return a suitable email.
Message getEmail({
  required final Session session,
  required final String to,
  required final String subject,
  required final String text,
}) =>
    Message()
      ..from = Address(
        session.passwords['smtpUsername']!,
        session.passwords['emailFromName'],
      )
      ..recipients.add(to)
      ..subject = subject
      ..text = text
      ..html = text;

/// Send an email.
Future<bool> sendMail(
  final Session session,
  final Message message, {
  final String errorMessage = 'Failed to send email.',
  final LogLevel logLevel = LogLevel.error,
}) async {
  try {
    await send(message, getSmtpSever(session));
    return true;
    // ignore: avoid_catches_without_on_clauses
  } catch (e, s) {
    session.log(
      errorMessage,
      exception: e,
      stackTrace: s,
      level: logLevel,
    );
    return false;
  }
}
