// Sendgrid environment variables
const String kSendgridAPI = "SENDGRID_API_KEY";
const String kEmailAddress = "EMAIL_ADDRESS";
const String kContactEmail = "CONTACT_EMAIL";

// Constants
const String kType = "text/plain";
String kContent(String name) => """
Dear ${name.toUpperCase()},

Your Otoscopia User Profile haas been verified!

We are looking forward to working with you. You may access your account via the Web, Desktop or Mobile Application.

Sincerely,

Otoscopia Team

This communication is intended solely for the use of the addressee. It may contain confidential or legally privileged information. If you are not the intended recipient, any disclosure, copying, distribution or taking any action in reliance on this communication is strictly prohibited and may be unlawful. If you received this communication in error, please notify the sender immediately and delete this communication from your system. Otoscopia is neither liable for the proper and complete transmission of this communication nor for any delay in its receipt.
""";

const String kSubject = "Otoscopia User Profile Verified";

const kEmailVerification = "emailVerification";
const kphoneVerification = "phoneVerification";
const kLabels = "labels";
const kDoctor = "doctor";
const kNurse = "nurse";

const String kData = "data";
const String kSuccess = "Email has been Sent Successfully.";

const String kName = "name";
const String kEmail = "email";

const String kEmailFailed = "User object has not been completed. The server will email the user if the user object is complete.";

// logs
const String kSettingUpSendgridMailer = "Setting up Sendgrid mailer...";
const String kDecodingRequestBody = "Decoding request body...";
const String kSettingUpEmail = "Setting up email content and subject...";
const String kSendingEmail = "Sending email...";
const String kEmailSent = "Email has been sent successfully.";
