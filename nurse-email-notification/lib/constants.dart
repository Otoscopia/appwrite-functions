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
const String kEmail = "email";
const String kType = "text/plain";
String kContent(String code) => """
A patient medical record has been modified, please check the patient's record for more information.
\n 
\n Regards, 
\n Otoscopia Team. 
\n https://otoscopia.vercel.app/
""";

const String kSubject = "New Patient has been added.";
const String kData = "data";
const String kSuccess = "Email has been Sent Successfully.";
const String kError = "error";
