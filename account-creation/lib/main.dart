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
    final response = context.req.bodyRaw;
    context.log(response);
    final userID = response[kID];
    context.log(userID);

    await databases.createDocument(
      databaseId: databaseID,
      collectionId: usersCollection,
      documentId: userID,
      data: {
        kName: response[kName],
        kRole: response[kRole],
        kEmail: response[kEmail],
        kPhone: response[kPhone],
        kPublicKey: response[kPublicKey],
        kWorkAddress: response[kWorkAddress],
      },
      permissions: [
        Permission.update(Role.user(userID)),
      ],
    );

    await user.updatePhone(userId: userID, number: response[kPhone]);
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
        kSchools: response[kSchools],
      },
    );

    content = Content(kType, kContent(response[kName], contactEmail));
    toAddress = Address(response[kEmail]);
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
