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
final String screeningCollection = Platform.environment[kScreeningCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  context.log(kSettingUpAppwriteClient);
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  context.log(kSettingUpAppwriteDatabase);
  final db = Databases(client);

  context.log(kSettingUpSendgridMailer);
  final mailer = Mailer(sendgridAPI);
  final fromAddress = Address(emailAddress);
  final subject = kSubject;

  List<Content> content = [];
  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  try {
    context.log(kDecodingRequestBody);
    final body = json.decode(context.req.bodyRaw);
    final collectionType = body[kCollectionID];
    if (collectionType == screeningCollection) {
      final doctorID = body[kPatients][kDoctor];

      context.log(kFetchingDoctorDetails);
      final response = await db.getDocument(
        databaseId: databaseID,
        collectionId: screeningCollection,
        documentId: doctorID,
      );

      final doctor = response.data;

      final doctorEmail = doctor[kEmail];
      toAddress = Address(doctorEmail);
      personalization = Personalization([toAddress]);

      final String name = doctor[kName];
      final String code = doctor[kCode];

      content.add(Content(kType, kContent(name, code)));
      email = Email([personalization], fromAddress, subject, content: content);

      context.log(kSendingEmail);
      await mailer.send(email);
    }

      context.log(kEmailSent);
    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    return context.res.json({
      kError: e.toString(),
    });
  }
}
