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
final String usersCollection = Platform.environment[kUsersCollection]!;
final String assignmentCollection =
    Platform.environment[kAssignmentCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;
final String contactEmail = Platform.environment[kContactEmail]!;

Future<dynamic> main(final context) async {
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  final databases = Databases(client);

  final user = Users(client);

  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  late final Content content;
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  try {
    final response = context.req.bodyRaw as Map<String, dynamic>;
    final userID = response[kID] as String;

    await databases.createDocument(
      databaseId: databaseID,
      collectionId: usersCollection,
      documentId: userID,
      data: {
        kName: response[kName] as String,
        kRole: response[kRole] as String,
        kEmail: response[kEmail] as String,
        kPhone: response[kPhone] as String,
        kPublicKey: response[kPublicKey] as String,
        kWorkAddress: response[kWorkAddress] as String,
      },
      permissions: [
        Permission.update(Role.user(userID)),
      ],
    );

    await user.updatePhone(userId: userID, number: response[kPhone] as String);
    // await user.updateLabels(
    // userId: '[USER_ID]',
    // labels: [],
    // );

    await databases.createDocument(
      databaseId: databaseID,
      collectionId: assignmentCollection,
      documentId: ID.unique(),
      data: {
        kIsActive: true,
        kUsers: userID,
        kSchools: response[kSchools] as String,
      },
    );

    content = Content(kType, kContent(response[kName] as String, contactEmail));
    toAddress = Address(response[kEmail] as String);
    personalization = Personalization([toAddress]);

    email = Email([personalization], fromAddress, subject, content: [content]);

    await mailer.send(email);

    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    context.error("$kError: $e");
    return context.res.send(kError);
  }
}
