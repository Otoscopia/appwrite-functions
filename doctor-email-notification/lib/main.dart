import 'dart:async';
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
final String screeningCollection = Platform.environment[kScreeningCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  final db = Databases(client);

  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  final content = Content(kType, kContent);
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  final collectionType = context.req.bodyRaw[kCollectionID] as String;

  try {
    if (collectionType == screeningCollection) {
      final doctorID = context.req.bodyRaw[kPatients][kDoctor] as String;
      final doctorResponse = await db.getDocument(
        databaseId: databaseID,
        collectionId: screeningCollection,
        documentId: doctorID,
      );

      final doctorEmail = doctorResponse.data[kEmail] as String;
      toAddress = Address(doctorEmail);
      personalization = Personalization([toAddress]);
    }

    email = Email([personalization], fromAddress, subject, content: [content]);

    await mailer.send(email);

    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    return context.res.json({
      kError: e.toString(),
    });
  }
}
