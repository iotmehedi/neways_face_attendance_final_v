class LoginModel {
  User? user;
  Attendance? attendance;
  var accessToken;
  var tokenType;

  LoginModel({this.user, this.attendance, this.accessToken, this.tokenType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}

class User {
  var id;
  var email;
  var fName;
  var lName;
  var fullName;
  var religion;
  var gender;
  var maritalStatus;
  var dateOfBirth;
  var dateOfJoining;
  var bloodGroup;
  var personalPhone;
  var contactPersonNumber;
  var avaterPhoto;
  var companyPhone;
  var companyEmail;
  var nidNumber;
  var branchId;
  var branchName;
  var branchCode;
  var currentAddress;
  var permanentAddress;
  var note;
  var employeeId;
  var roleId;
  var roleName;
  var roleCode;
  var departmentId;
  var departmentName;
  var departmentCode;
  var designationId;
  var designationName;
  var designationCode;
  var basicSalaryMonthly;
  var basicSalaryDaily;
  var mobileAllowance;
  var salaryPayMethod;
  var contructType;
  var accessCard;
  var whiteList;
  var observationList;
  var exitProcessList;
  var roasterId;
  var roasterName;
  var roasterCode;
  var weekenDayId;
  var weekenDayName;
  var status;
  var uploaderInfo;
  var data;
  var dateFilter;
  var rosterName;
  var rosterCode;
  var dutyHour;
  var startTime;
  var endTime;
  var startHour;
  var startMin;
  var startAmpm;
  var endHour;
  var endMin;
  var endAmpm;
  var includeMealBreak;
  var isAttendanceWhiteList;

  User(
      {this.id,
        this.email,
        this.fName,
        this.lName,
        this.fullName,
        this.religion,
        this.gender,
        this.maritalStatus,
        this.dateOfBirth,
        this.dateOfJoining,
        this.bloodGroup,
        this.personalPhone,
        this.contactPersonNumber,
        this.avaterPhoto,
        this.companyPhone,
        this.companyEmail,
        this.nidNumber,
        this.branchId,
        this.branchName,
        this.branchCode,
        this.currentAddress,
        this.permanentAddress,
        this.note,
        this.employeeId,
        this.roleId,
        this.roleName,
        this.roleCode,
        this.departmentId,
        this.departmentName,
        this.departmentCode,
        this.designationId,
        this.designationName,
        this.designationCode,
        this.basicSalaryMonthly,
        this.basicSalaryDaily,
        this.mobileAllowance,
        this.salaryPayMethod,
        this.contructType,
        this.accessCard,
        this.whiteList,
        this.observationList,
        this.exitProcessList,
        this.roasterId,
        this.roasterName,
        this.roasterCode,
        this.weekenDayId,
        this.weekenDayName,
        this.status,
        this.uploaderInfo,
        this.data,
        this.dateFilter,
        this.rosterName,
        this.rosterCode,
        this.dutyHour,
        this.startTime,
        this.endTime,
        this.startHour,
        this.startMin,
        this.startAmpm,
        this.endHour,
        this.endMin,
        this.endAmpm,
        this.includeMealBreak,
      this.isAttendanceWhiteList,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fName = json['f_name'];
    lName = json['l_name'];
    fullName = json['full_name'];
    religion = json['religion'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    dateOfBirth = json['date_of_birth'];
    dateOfJoining = json['date_of_joining'];
    bloodGroup = json['blood_group'];
    personalPhone = json['personal_Phone'];
    contactPersonNumber = json['contact_person_number'];
    avaterPhoto = json['avater_photo'];
    companyPhone = json['company_phone'];
    companyEmail = json['company_email'];
    nidNumber = json['nid_number'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    branchCode = json['branch_code'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    note = json['note'];
    employeeId = json['employee_id'];
    roleId = json['role_id'];
    roleName = json['role_name'];
    roleCode = json['role_code'];
    departmentId = json['department_id'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
    designationId = json['designation_id'];
    designationName = json['designation_name'];
    designationCode = json['designation_code'];
    basicSalaryMonthly = json['basic_salary_monthly'];
    basicSalaryDaily = json['basic_salary_daily'];
    mobileAllowance = json['mobile_allowance'];
    salaryPayMethod = json['salary_pay_method'];
    contructType = json['contruct_type'];
    accessCard = json['access_card'];
    whiteList = json['white_list'];
    observationList = json['observation_list'];
    exitProcessList = json['exit_process_list'];
    roasterId = json['roaster_id'];
    roasterName = json['roaster_name'];
    roasterCode = json['roaster_code'];
    weekenDayId = json['weeken_day_id'];
    weekenDayName = json['weeken_day_name'];
    status = json['status'];
    uploaderInfo = json['uploader_info'];
    data = json['data'];
    dateFilter = json['date_filter'];
    rosterName = json['roster_name'];
    rosterCode = json['roster_code'];
    dutyHour = json['duty_hour'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    startHour = json['start_hour'];
    startMin = json['start_min'];
    startAmpm = json['start_ampm'];
    endHour = json['end_hour'];
    endMin = json['end_min'];
    endAmpm = json['end_ampm'];
    includeMealBreak = json['include_meal_break'];
    isAttendanceWhiteList = json['is_attendance_white_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['full_name'] = this.fullName;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['date_of_birth'] = this.dateOfBirth;
    data['date_of_joining'] = this.dateOfJoining;
    data['blood_group'] = this.bloodGroup;
    data['personal_Phone'] = this.personalPhone;
    data['contact_person_number'] = this.contactPersonNumber;
    data['avater_photo'] = this.avaterPhoto;
    data['company_phone'] = this.companyPhone;
    data['company_email'] = this.companyEmail;
    data['nid_number'] = this.nidNumber;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    data['branch_code'] = this.branchCode;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['note'] = this.note;
    data['employee_id'] = this.employeeId;
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    data['role_code'] = this.roleCode;
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    data['designation_id'] = this.designationId;
    data['designation_name'] = this.designationName;
    data['designation_code'] = this.designationCode;
    data['basic_salary_monthly'] = this.basicSalaryMonthly;
    data['basic_salary_daily'] = this.basicSalaryDaily;
    data['mobile_allowance'] = this.mobileAllowance;
    data['salary_pay_method'] = this.salaryPayMethod;
    data['contruct_type'] = this.contructType;
    data['access_card'] = this.accessCard;
    data['white_list'] = this.whiteList;
    data['observation_list'] = this.observationList;
    data['exit_process_list'] = this.exitProcessList;
    data['roaster_id'] = this.roasterId;
    data['roaster_name'] = this.roasterName;
    data['roaster_code'] = this.roasterCode;
    data['weeken_day_id'] = this.weekenDayId;
    data['weeken_day_name'] = this.weekenDayName;
    data['status'] = this.status;
    data['uploader_info'] = this.uploaderInfo;
    data['data'] = this.data;
    data['date_filter'] = this.dateFilter;
    data['roster_name'] = this.rosterName;
    data['roster_code'] = this.rosterCode;
    data['duty_hour'] = this.dutyHour;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['start_hour'] = this.startHour;
    data['start_min'] = this.startMin;
    data['start_ampm'] = this.startAmpm;
    data['end_hour'] = this.endHour;
    data['end_min'] = this.endMin;
    data['end_ampm'] = this.endAmpm;
    data['include_meal_break'] = this.includeMealBreak;
    data['is_attendance_white_list'] = this.isAttendanceWhiteList;
    return data;
  }
}

class Attendance {
  var id;
  var employeeId;
  var companyId;
  var fullName;
  var departmentId;
  var departmentName;
  var attendance;
  var attendanceDate;
  var attendanceYear;
  var attendanceMonth;
  var attendanceDay;
  var checkinTime;
  var checkinHour;
  var checkinMinit;
  var checkinAmPm;
  var checkoutTime;
  var checkoutHour;
  var checkoutMinit;
  var checkoutAmPm;
  var note;
  var status;
  var uploaderInfo;
  var data;
  var dateFilter;

  Attendance(
      {this.id,
        this.employeeId,
        this.companyId,
        this.fullName,
        this.departmentId,
        this.departmentName,
        this.attendance,
        this.attendanceDate,
        this.attendanceYear,
        this.attendanceMonth,
        this.attendanceDay,
        this.checkinTime,
        this.checkinHour,
        this.checkinMinit,
        this.checkinAmPm,
        this.checkoutTime,
        this.checkoutHour,
        this.checkoutMinit,
        this.checkoutAmPm,
        this.note,
        this.status,
        this.uploaderInfo,
        this.data,
        this.dateFilter});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    companyId = json['company_id'];
    fullName = json['full_name'];
    departmentId = json['department_id'];
    departmentName = json['department_name'];
    attendance = json['attendance'];
    attendanceDate = json['attendance_date'];
    attendanceYear = json['attendance_year'];
    attendanceMonth = json['attendance_month'];
    attendanceDay = json['attendance_day'];
    checkinTime = json['checkin_time'];
    checkinHour = json['checkin_hour'];
    checkinMinit = json['checkin_minit'];
    checkinAmPm = json['checkin_am_pm'];
    checkoutTime = json['checkout_time'];
    checkoutHour = json['checkout_hour'];
    checkoutMinit = json['checkout_minit'];
    checkoutAmPm = json['checkout_am_pm'];
    note = json['note'];
    status = json['status'];
    uploaderInfo = json['uploader_info'];
    data = json['data'];
    dateFilter = json['date_filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['company_id'] = this.companyId;
    data['full_name'] = this.fullName;
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    data['attendance'] = this.attendance;
    data['attendance_date'] = this.attendanceDate;
    data['attendance_year'] = this.attendanceYear;
    data['attendance_month'] = this.attendanceMonth;
    data['attendance_day'] = this.attendanceDay;
    data['checkin_time'] = this.checkinTime;
    data['checkin_hour'] = this.checkinHour;
    data['checkin_minit'] = this.checkinMinit;
    data['checkin_am_pm'] = this.checkinAmPm;
    data['checkout_time'] = this.checkoutTime;
    data['checkout_hour'] = this.checkoutHour;
    data['checkout_minit'] = this.checkoutMinit;
    data['checkout_am_pm'] = this.checkoutAmPm;
    data['note'] = this.note;
    data['status'] = this.status;
    data['uploader_info'] = this.uploaderInfo;
    data['data'] = this.data;
    data['date_filter'] = this.dateFilter;
    return data;
  }
}
