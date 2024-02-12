import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:starter_template/constants.dart';

// Appwrite Database environment variables
final String remarksCollection = Platform.environment[kRemarksCollection]!;

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  context.log(kSettingUpSendgridMailer);
  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Content content;
  late final Email email;

  try {
    context.log(kDecodingRequestBody);
    final body = json.decode(context.req.bodyRaw);

    context.log(kSettingUpEmail);
    content = Content(kType, kContent(body[kName], body[kCode]));
    toAddress = Address(body[kEmail]);
    personalization = Personalization([toAddress]);

    email = Email([personalization], fromAddress, subject, content: [content]);

    context.log(kSendingEmail);
    await mailer.send(email);
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
