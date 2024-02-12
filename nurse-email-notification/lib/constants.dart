// Appwrite Database environment variables
const String kRemarksCollection = "REMARKS_COLLECTION";

// Sendgrid environment variables
const String kSendgridAPI = "SENDGRID_API_KEY";
const String kEmailAddress = "EMAIL_ADDRESS";

// Constants
const String kCollectionID = "\$collectionId";
const String kPatients = "patients";
const String kCode = "code";
const String kScreening = "screening";
const String kAssignment = "assignment";
const String kUsers = "users";
const String kName = "name";
const String kEmail = "email";
const String kType = "text/plain";
String kContent(String name, String code) => """
Dear Nurse $name,

Your patient with the following code: $code and its medical record has been updated. Please log in to your Otoscopia account to view the patient's details along with the updated medical record. Please take necessary action if required and update the patients guardian about the status of the patient.

Thank you and we look forward to the successful treatment of the patient.

Sincerely,

Otoscopia Team

This communication is intended solely for the use of the addressee. It may contain confidential or legally privileged information. If you are not the intended recipient, any disclosure, copying, distribution or taking any action in reliance on this communication is strictly prohibited and may be unlawful. If you received this communication in error, please notify the sender immediately and delete this communication from your system. Otoscopia is neither liable for the proper and complete transmission of this communication nor for any delay in its receipt.
""";

const String kSubject = "Patient Medical Record Has Been Modified.";
const String kData = "data";
const String kSuccess = "Email has been Sent Successfully.";
const String kError = "error";

const String kSettingUpSendgridMailer = "Setting up Sendgrid mailer...";
const String kDecodingRequestBody = "Decoding request body...";
const String kSettingUpEmail = "Setting up email content and subject...";
const String kSendingEmail = "Sending email...";
const String kEmailSent = "Email has been sent successfully.";