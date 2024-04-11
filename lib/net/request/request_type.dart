class MasterRequestType {
  // Login/Logout
  static const String masterLogin = "MANAGEMENT_LOGIN";
  static const String logout = "LOGOUT";

  // Authorization
  static const String authorizeAccess = "AUTHORIZE_ACCESS";
  static const String authorizeShift = "AUTHORIZE_SHIFT";

  // Settings
  static const String verifyVersion = "VERIFY_VERSION";

  //Tool / Device
  static const String createDevice = "CREATE_DEVICE";
  static const String updateDevice = "UPDATE_DEVICE";
  static const String deleteDevice = "DELETE_DEVICE";
  static const String queryDevice = "QUERY_DEVICE";
  static const String queryDevices = "QUERY_DEVICES";

  //Company
  static const String queryCompanies = "QUERY_COMPANIES";
  static const String queryCompany = "QUERY_COMPANY";
  static const String createCompany = "CREATE_COMPANY";
  static const String updateCompany = "UPDATE_COMPANY";
  static const String deleteCompany = "DELETE_COMPANY";
  static const String manajementCompany = "MANAJEMEN_COMPANY"; //Remove later after migration

  //User
  static const String queryUsers = "QUERY_USERS";
  static const String createUser = "CREATE_USER";
  static const String updateUser = "UPDATE_USER";
  static const String deleteUser = "DELETE_USER";

  //Template
  static const String queryTemplates = "QUERY_TEMPLATES";
  static const String queryTemplate = "QUERY_TEMPLATE";
  static const String managementTemplate = "MANAGEMENT_TEMPLATE";

  //Examination
  static const String assignExamination = "ASSIGN_EXAMINATION";
  static const String queryTypeExaminations = "QUERY_TYPE_EXAMINATIONS";
  static const String queryExaminations = "QUERY_EXAMINATIONS";
  static const String queryExamination = "QUERY_EXAMINATION";
  static const String saveExaminationKebisinganLK = "SAVE_EXAMINATION_KEBISINGAN_LK";
  static const String submitExaminationKebisinganLK = "SUBMIT_EXAMINATION_KEBISINGAN_LK";
  static const String saveExaminationKebisinganFrekuensi = "SAVE_EXAMINATION_KEBISINGAN_FREKUENSI";
  static const String submitExaminationKebisinganFrekuensi = "SUBMIT_EXAMINATION_KEBISINGAN_FREKUENSI";
  static const String saveExaminationPenerangan = "SAVE_EXAMINATION_PENERANGAN";
  static const String submitExaminationPenerangan = "SUBMIT_EXAMINATION_PENERANGAN";
  static const String approvalQC1 = "APPROVAL_QC1";
  static const String approvalQC2 = "APPROVAL_QC2";
  static const String approvalSigned = "APPROVAL_SIGNED";
  static const String submitRevision = "REVISION_EXAMINATION";
  static const String inputLab = "INPUT_LAB";
}
