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

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;
final String contactEmail = Platform.environment[kContactEmail]!;

Future<dynamic> main(final context) async {
  context.log('Setting up Appwrite client...');
  final client = Client()
      .setEndpoint(projectEndpoint)
      .setProject(projectID)
      .setKey(appwriteApi);

  context.log('Setting up Appwrite database...');
  final databases = Databases(client);

  context.log('Setting up Appwrite users...');
  final user = Users(client);

  context.log('Setting up Sendgrid mailer...');
  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  late final Content content;
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  try {
    final body = json.decode(context.req.bodyRaw);
    context.log(body.runtimeType);

    // final jsonBody = json.decode(body);
    // context.log(json.encode(jsonBody.runtimeType));
    
    // final userID = jsonBody[kID];
    // context.log(userID);

    // context.log('Creating user...');
    // await databases.createDocument(
    //   databaseId: databaseID,
    //   collectionId: usersCollection,
    //   documentId: userID,
    //   data: {
    //     kName: jsonBody[kName],
    //     kRole: jsonBody[kRole],
    //     kEmail: jsonBody[kEmail],
    //     kPhone: jsonBody[kPhone],
    //     kPublicKey: jsonBody[kPublicKey],
    //     kWorkAddress: jsonBody[kWorkAddress],
    //   },
    //   permissions: [
    //     Permission.update(Role.user(userID)),
    //   ],
    // );

    // context.log('Updating user...');
    // await user.updatePhone(userId: userID, number: jsonBody[kPhone]);
    // // await user.updateLabels(
    // // userId: '[USER_ID]',
    // // labels: [],
    // // );

    // await databases.createDocument(
    //   databaseId: databaseID,
    //   collectionId: assignmentCollection,
    //   documentId: ID.unique(),
    //   data: {
    //     kIsActive: true,
    //     kUsers: userID,
    //     kSchools: jsonBody[kSchools],
    //   },
    // );

    // content =
    //     Content(kType, kContent(jsonBody[kName], contactEmail));
    // toAddress = Address(jsonBody[kEmail]);
    // personalization = Personalization([toAddress]);

    // email = Email([personalization], fromAddress, subject, content: [content]);

    // context.log('Sending email...');
    // await mailer.send(email);

    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    context.error("$kError: $e");
    return context.res.send(kError);
  }
}
