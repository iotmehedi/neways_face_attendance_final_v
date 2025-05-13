class GetEmployeeFaceModel {
  var success;
  List<EmployeeFaceAttendance>? employeeFaceAttendance;

  GetEmployeeFaceModel({this.success, this.employeeFaceAttendance});

  GetEmployeeFaceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['employeeFaceAttendance'] != null) {
      employeeFaceAttendance = <EmployeeFaceAttendance>[];
      json['employeeFaceAttendance'].forEach((v) {
        employeeFaceAttendance!.add(new EmployeeFaceAttendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.employeeFaceAttendance != null) {
      data['employeeFaceAttendance'] =
          this.employeeFaceAttendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeFaceAttendance {
  var id;
  var employeeId;
  var imageUrl;
  var thumbUrl;
  var uploaderInfo;
  var data;
  var dateFilter;

  EmployeeFaceAttendance(
      {this.id,
      this.employeeId,
      this.imageUrl,
      this.thumbUrl,
      this.uploaderInfo,
      this.data,
      this.dateFilter});

  EmployeeFaceAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    uploaderInfo = json['uploader_info'];
    data = json['data'];
    dateFilter = json['date_filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['uploader_info'] = this.uploaderInfo;
    data['data'] = this.data;
    data['date_filter'] = this.dateFilter;
    return data;
  }
}
