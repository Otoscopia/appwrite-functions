import 'dart:async';
import 'dart:io';

// import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

final String? projectEndpoint = Platform.environment['APPWRITE_ENDPOINT'];
final String? projectId = Platform.environment['APPWRITE_PROJECT_ID'];
final String? appwriteApi = Platform.environment['APPWRITE_API_KEY'];
final String? sendgridApiKey = Platform.environment['SENDGRID_API_KEY'];

Future<dynamic> main(final context) async {
  if (projectEndpoint == null ||
      projectId == null ||
      appwriteApi == null ||
      sendgridApiKey == null) {
    return context.res.json({
      'error':
          'Please set the APPWRITE_ENDPOINT, APPWRITE_FUNCTION_PROJECT_ID, APPWRITE_API_KEY and SENDGRID_API_KEY environment variables',
    });
  }

  // final client = Client()
  //     .setEndpoint(projectEndpoint!)
  //     .setProject(projectId)
  //     .setKey(appwriteApi);

  final mailer = Mailer(sendgridApiKey!);
  final toAddress = Address('SEND TO EMAIL');
  final fromAddress = Address('admin@otoscopia.me');
  final content =
      Content('text/plain', 'Appwrite Database successfully updated');
  final subject = 'Database Update Alert!';
  final personalization = Personalization([toAddress]);

  final email =
      Email([personalization], fromAddress, subject, content: [content]);
  mailer.send(email).then((result) {
    print(result);
  }).catchError((onError) {
    print('error');
  });

  context.res.json({
    'data': "testing emails",
  });
}
