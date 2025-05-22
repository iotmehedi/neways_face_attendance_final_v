class GetAttendanceModel {
  String? status;
  String? code;
  Attendance? attendance;
  List<AttendanceStatus>? attendanceStatus;

  GetAttendanceModel(
      {this.status, this.code, this.attendance, this.attendanceStatus});

  GetAttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
    if (json['attendance_status'] != null) {
      attendanceStatus = <AttendanceStatus>[];
      json['attendance_status'].forEach((v) {
        attendanceStatus!.add(new AttendanceStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    if (this.attendanceStatus != null) {
      data['attendance_status'] =
          this.attendanceStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? id;
  String? employeeId;
  String? companyId;
  String? fullName;
  String? departmentId;
  String? departmentName;
  String? attendance;
  String? attendanceDate;
  String? attendanceYear;
  String? attendanceMonth;
  String? attendanceDay;
  String? checkinTime;
  String? checkinHour;
  String? checkinMinit;
  String? checkinAmPm;
  String? checkoutTime;
  String? checkoutHour;
  String? checkoutMinit;
  String? checkoutAmPm;
  String? note;
  String? status;
  String? uploaderInfo;
  String? data;
  String? dateFilter;
  String? createdAt;
  String? updatedAt;

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
        this.dateFilter,
        this.createdAt,
        this.updatedAt});

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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AttendanceStatus {
  String? id;
  String? employeeId;
  String? attendanceId;
  String? rosterId;
  String? attendanceDate;
  String? type;
  String? intiming;
  String? tima;
  String? uploaderInfo;
  String? data;
  String? dateFilter;
  String? createdAt;
  String? updatedAt;

  AttendanceStatus(
      {this.id,
        this.employeeId,
        this.attendanceId,
        this.rosterId,
        this.attendanceDate,
        this.type,
        this.intiming,
        this.tima,
        this.uploaderInfo,
        this.data,
        this.dateFilter,
        this.createdAt,
        this.updatedAt});

  AttendanceStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    attendanceId = json['attendance_id'];
    rosterId = json['roster_id'];
    attendanceDate = json['attendance_date'];
    type = json['type'];
    intiming = json['intiming'];
    tima = json['tima'];
    uploaderInfo = json['uploader_info'];
    data = json['data'];
    dateFilter = json['date_filter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['attendance_id'] = this.attendanceId;
    data['roster_id'] = this.rosterId;
    data['attendance_date'] = this.attendanceDate;
    data['type'] = this.type;
    data['intiming'] = this.intiming;
    data['tima'] = this.tima;
    data['uploader_info'] = this.uploaderInfo;
    data['data'] = this.data;
    data['date_filter'] = this.dateFilter;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
