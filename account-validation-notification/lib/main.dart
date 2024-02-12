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
  late final Content content;
  final subject = kSubject;

  late final Address toAddress;
  late final Personalization personalization;
  late final Email email;

  try {
    context.log(kDecodingRequestBody);
    final body = json.decode(context.req.bodyRaw);

    final emailVerified = body[kEmailVerification];
    final phoneVerified = body[kphoneVerification];
    final List<String> labels = List<String>.from(body[kLabels]);

    if (emailVerified && phoneVerified && labels.contains(kDoctor) ||
        labels.contains(kNurse)) {
      context.log(kSettingUpEmail);
      content = Content(kType, kContent(body[kName]));
      toAddress = Address(body[kEmail]);
      personalization = Personalization([toAddress]);

      email =
          Email([personalization], fromAddress, subject, content: [content]);

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
