import 'dart:async';
import 'dart:io';

// import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

final String projectEndpoint = Platform.environment['APPWRITE_ENDPOINT']!;
final String projectId = Platform.environment['APPWRITE_PROJECT_ID']!;
final String appwriteApi = Platform.environment['APPWRITE_API_KEY']!;
final String sendgridApiKey = Platform.environment['SENDGRID_API_KEY']!;
final String emailAddress =
    Platform.environment['EMAIL_ADDRESS']!; // ! for testing purposes only

Future<dynamic> main(final context) async {
  // final client = Client()
  //     .setEndpoint(projectEndpoint!)
  //     .setProject(projectId)
  //     .setKey(appwriteApi);

  final mailer = Mailer(sendgridApiKey);
  final toAddress = Address(emailAddress);
  final fromAddress = Address('admin@otoscopia.me');
  final content =
      Content('text/plain', 'Appwrite Database successfully updated');
  final subject = 'Database Update Alert!';
  final personalization = Personalization([toAddress]);

  final email =
      Email([personalization], fromAddress, subject, content: [content]);

  try {
    await mailer.send(email);

    return context.res.json({
      'data': "testing emails",
    });
  } catch (e) {
    return context.res.json({
      'error': e.toString(),
    });
  }
}
