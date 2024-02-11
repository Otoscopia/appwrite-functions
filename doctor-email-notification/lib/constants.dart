// Appwrite Client environment variables
const String kEndpoint = "APPWRITE_ENDPOINT";
const String kProjectID = "APPWRITE_PROJECT_ID";
const String kAppwriteAPI = "APPWRITE_API_KEY";

// Appwrite Database environment variables
const String kDatabaseID = "DATABASE_ID";
const String kScreeningCollection = "SCREENING_COLLECTION";

// Sendgrid environment variables
const String kSendgridAPI = "SENDGRID_API_KEY";
const String kEmailAddress = "EMAIL_ADDRESS";

// Constants
const String kCollectionID = "\$collectionId";
const String kName = "name";
const String kCode = "code";
const String kPatients = "patients";
const String kDoctor = "doctor";
const String kEmail = "email";
const String kType = "text/plain";
String kContent(String name, String code) => """
Dear Doctor $name,

A new patient has been added to your list with the following code: $code. Please log in to your Otoscopia account to view the patient's details and to schedule an appointment with the patient if necessary.

Thank you and we look forward to the successful treatment of the patient.

Sincerely,

Otoscopia Team

This communication is intended solely for the use of the addressee. It may contain confidential or legally privileged information. If you are not the intended recipient, any disclosure, copying, distribution or taking any action in reliance on this communication is strictly prohibited and may be unlawful. If you received this communication in error, please notify the sender immediately and delete this communication from your system. Otoscopia is neither liable for the proper and complete transmission of this communication nor for any delay in its receipt.
""";

const String kSubject = "New Patient has been added.";
const String kData = "data";
const String kSuccess = "Email has been Sent Successfully.";
const String kError = "error";

// logs
const String kSettingUpAppwriteClient = "Setting up Appwrite client...";
const String kSettingUpAppwriteDatabase = "Setting up Appwrite database...";
const String kSettingUpSendgridMailer = "Setting up Sendgrid mailer...";
const String kDecodingRequestBody = "Decoding request body...";
const String kFetchingDoctorDetails = "Fetching doctor details...";
const String kSendingEmail = "Sending email...";
const String kEmailSent = "Email has been sent successfully.";
