import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

final String projectEndpoint = Platform.environment['APPWRITE_ENDPOINT']!;
final String projectId = Platform.environment['APPWRITE_PROJECT_ID']!;
final String appwriteApi = Platform.environment['APPWRITE_API_KEY']!;
final String sendgridApiKey = Platform.environment['SENDGRID_API_KEY']!;
final String emailAddress = Platform.environment['EMAIL_ADDRESS']!;

Future<dynamic> main(final context) async {
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectId)
      .setKey(appwriteApi);

  final database = Databases(client);

  context.log(context.req.bodyRaw);
  context.log(json.encode(context.req.body));
  context.log(json.encode(context.req.headers));
  context.log(context.req.scheme);
  context.log(context.req.method);
  context.log(context.req.url);
  context.log(context.req.host);
  context.log(context.req.port);
  context.log(context.req.path);
  context.log(context.req.queryString);
  context.log(json.encode(context.req.query));

  context.log(context.toString());

  final mailer = Mailer(sendgridApiKey);
  final toAddress = Address(emailAddress);
  final fromAddress = Address("laurencetroy.valdez@g.msuiit.edu.ph");
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
