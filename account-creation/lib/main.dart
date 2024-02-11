import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:starter_template/constants.dart';

// Appwrite Client environment variables
final String projectEndpoint = Platform.environment[kEndpoint]!;
final String projectID = Platform.environment[kProjectID]!;
final String appwriteApi = Platform.environment[kAppwriteAPI]!;

// Appwrite Database environment variables
final String databaseID = Platform.environment[kDatabaseID]!;
final String usersCollection = Platform.environment[kUsersCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  final databases = Databases(client);

  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  final content = Content(kType, kContent);
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  try {
    // await databases.createDocument(
    //   databaseId: '[DATABASE_ID]',
    //   collectionId: '[COLLECTION_ID]',
    //   documentId: ID.unique(),
    //   data: {},
    // );

    toAddress = Address("laurencetroyv@gmail.com");
    personalization = Personalization([toAddress]);

    email = Email([personalization], fromAddress, subject, content: [content]);

    // await mailer.send(email);

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

    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    context.error("Failed to create document: $e");
    return context.res.send("Failed to create document");
  }
}
