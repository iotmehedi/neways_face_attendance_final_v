class AttendanceBindingModel {
  var success;
  var approval;
  List<AttendanceBinding>? attendanceBinding;

  AttendanceBindingModel({this.success, this.approval, this.attendanceBinding});

  AttendanceBindingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    approval = json['approval'];
    if (json['attendanceBinding'] != null) {
      attendanceBinding = <AttendanceBinding>[];
      json['attendanceBinding'].forEach((v) {
        attendanceBinding!.add(new AttendanceBinding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['approval'] = this.approval;
    if (this.attendanceBinding != null) {
      data['attendanceBinding'] =
          this.attendanceBinding!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceBinding {
  var id;
  var branchId;
  var wifiAddress;
  var note;
  var uploaderInfo;
  var createdAt;
  var updatedAt;

  AttendanceBinding(
      {this.id,
        this.branchId,
        this.wifiAddress,
        this.note,
        this.uploaderInfo,
        this.createdAt,
        this.updatedAt});

  AttendanceBinding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    wifiAddress = json['wifi_address'];
    note = json['note'];
    uploaderInfo = json['uploader_info'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['wifi_address'] = this.wifiAddress;
    data['note'] = this.note;
    data['uploader_info'] = this.uploaderInfo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
