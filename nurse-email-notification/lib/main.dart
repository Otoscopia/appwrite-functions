import 'dart:async';
import 'dart:io';

import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:starter_template/constants.dart';

// Appwrite Database environment variables
final String remarksCollection = Platform.environment[kRemarksCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Content content;
  late final Email email;

  final collectionType = context.req.bodyRaw[kCollectionID] as String;

  if (collectionType == remarksCollection) {
    final nurse = context.req.bodyRaw[kScreening][kAssignment];
    final nurseEmail = nurse[kUsers][kEmail] as String;

    final code = context.req.bodyRaw[kPatients][kCode] as String;

    toAddress = Address(nurseEmail);
    personalization = Personalization([toAddress]);
    content = Content(kType, kContent(code));
  }

  email = Email([personalization], fromAddress, subject, content: [content]);

  try {
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
