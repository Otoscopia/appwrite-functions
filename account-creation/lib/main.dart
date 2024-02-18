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
final String assignmentCollection =
    Platform.environment[kAssignmentCollection]!;
final String schoolCollection = Platform.environment[kSchoolCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;
final adminEmail = Platform.environment[kAdminAddress]!;
final String contactEmail = Platform.environment[kContactEmail]!;

Future<dynamic> main(final context) async {
  context.log(kSettingUpAppwriteClient);
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  context.log(kSettingUpAppwriteDatabase);
  final databases = Databases(client);

  context.log(kSettingUpAppwriteUsers);
  final user = Users(client);

  context.log(kSettingUpSendgridMailer);
  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  late Content content;
  final subject = kSubject;

  late Address toAddress;
  late Personalization personalization;
  late Email email;

  try {
    context.log(kDecodingRequestBody);
    final body = json.decode(context.req.bodyRaw);

    final userID = body[kID];

    context.log(kCreatingUser);
    await databases.createDocument(
      databaseId: databaseID,
      collectionId: usersCollection,
      documentId: userID,
      data: {
        kName: body[kName],
        kRole: body[kRole],
        kEmail: body[kEmail],
        kPhone: body[kPhone],
        kPublicKey: body[kPublicKey],
        kWorkAddress: body[kWorkAddress],
      },
      permissions: [
        Permission.update(Role.user(userID)),
      ],
    );

    context.log(kUpdatingUser);
    await user.updatePhone(userId: userID, number: body[kPhone]);

    if (body[kRole] == kNurse) {
      context.log(kCreatingAssignment);
      context.log(body.toString());
      context.log(body[kSchool].runtimeType);
      final schools = List<String>.from(body[kSchool]);

      context.log(kUpdatingSchool);
      for (final school in schools) {
        await databases.createDocument(
          databaseId: databaseID,
          collectionId: assignmentCollection,
          documentId: ID.unique(),
          data: {
            kIsActive: true,
            kNurse: userID,
            kSchool: body[kSchool],
          },
        );

        await databases.updateDocument(
          databaseId: databaseID,
          collectionId: schoolCollection,
          documentId: school,
          data: {
            isAssigned: true,
          },
        );
      }
    }

    context.log(kSettingUpEmail);
    content = Content(kType, kContent(body[kName], contactEmail));
    toAddress = Address(body[kEmail]);
    personalization = Personalization([toAddress]);

    email = Email([personalization], fromAddress, subject, content: [content]);

    context.log(kSendingEmail);
    await mailer.send(email);

    context.log(kEmailSent);

    context.log(kSettingUpAdminEmail);
    content = Content(kType, kAdminContent(userID, body[kRole]));
    toAddress = Address(adminEmail);
    personalization = Personalization([toAddress]);

    email = Email([personalization], fromAddress, subject, content: [content]);

    context.log(kSendingEmail);
    await mailer.send(email);

    context.log(kEmailSent);
    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    context.error("$kError: $e");
    return context.res.send(kError);
  }
}
