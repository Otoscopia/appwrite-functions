import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:starter_template/constants.dart';

// Sendgrid environment variables
final String sendgridAPI = Platform.environment[kSendgridAPI]!;
final String emailAddress = Platform.environment[kEmailAddress]!;

Future<dynamic> main(final context) async {
  context.log(kSettingUpSendgridMailer);
  final mailer = Mailer(sendgridAPI);

  final fromAddress = Address(emailAddress);
  late final List<Content> contents = [];
  final subject = kSubject;

  late final Address toAddress;
  late final List<Personalization> personalizations = [];
  late final Email email;

  try {
    context.log(kDecodingRequestBody);
    final body = json.decode(context.req.bodyRaw);

    context.log(kValidation);
    final emailVerified = body[kEmailVerification];

    final phoneVerified = body[kphoneVerification];

    final List<String> labels = List<String>.from(body[kLabels]);

    final hasRole = labels.contains(kDoctor) || labels.contains(kNurse);

    final isVerified = emailVerified && phoneVerified && hasRole;

    if (isVerified) {
      context.log(kSettingUpEmail);
      contents.add(Content(kType, kContent(body[kName])));

      toAddress = Address(body[kEmail]);

      personalizations.add(Personalization([toAddress]));

      email = Email(personalizations, fromAddress, subject, content: contents);

      context.log(kSendingEmail);
      await mailer.send(email);

      context.log(kEmailSent);
    } else {
      context.log(kEmailFailed);
    }

    return context.res.json({
      kData: kSuccess,
    });
  } catch (e) {
    context.error(e.toString());
    return context.res.send(e.toString());
  }
}
