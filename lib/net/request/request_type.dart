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
  static const String managementAlat = "MANAGEMENT_ALAT";
  static const String queryDevices = "QUERY_DEVICES";

  //Company
  static const String queryCompanies = "QUERY_COMPANIES";
  static const String queryCompany = "QUERY_COMPANY";
  static const String createCompany = "CREATE_COMPANY";
  static const String updateCompany = "UPDATE_COMPANY";
  static const String deleteCompany = "DELETE_COMPANY";

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
  static const String queryTypeExaminations = "QUERY_TYPE_EXAMINATIONS";
  static const String queryExaminations = "QUERY_EXAMINATIONS";
  static const String saveExaminationKebisinganLK = "SAVE_EXAMINATION_KEBISINGAN_LK";
  static const String inputExaminationKebisinganLK = "INPUT_EXAMINATION_KEBISINGAN_LK";
  static const String resultExaminationKebisinganLK = "RESULT_EXAMINATION_KEBISINGAN_LK";
  static const String saveExaminationPencahayaan = "SAVE_EXAMINATION_PENCAHAYAAN";
  static const String inputExaminationPencahayaan = "INPUT_EXAMINATION_PENCAHAYAAN";
  static const String resultExaminationPencahayaan = "RESULT_EXAMINATION_PENCAHAYAAN";
  static const String approvalQC1 = "APPROVAL_QC1";
}
