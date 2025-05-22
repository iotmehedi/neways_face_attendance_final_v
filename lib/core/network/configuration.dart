class NetworkConfiguration {
  // static const String baseUrl = "https://app.neways3.com/api/";
  static const String baseUrl = "https://erp.neways3.com/api/employee/";
  static const String differentBaseUrl = "https://erp.neways3.com/api/employee/auth/";
  static const String imageUrl = "https://documents.neways3.com/";
  static const String registration = "registration";
  static const String login = "auth/login";
  static const String sendOTP = "auth/send-otp";
  static const String getEmployeeFace = "attendance/get-employee-face";
  static const String getRoster = "attendance/get-roster";
  static const String getAttendance = "attendance/get-attendance";

  static const String setAttendance = "attendance/submit-attendance";
  static const String forgotPassword = "set-attendance";
  static const String profile = "employee-profile";
  static const String attendanceBinding = "attendance/attendance-wifi";

  static const int connectionError = -1;
}
