class GetRoasterModel {
  String? status;
  String? code;
  RoastingInfo? roastingInfo;

  GetRoasterModel({this.status, this.code, this.roastingInfo});

  GetRoasterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    roastingInfo = json['roasting_info'] != null
        ? new RoastingInfo.fromJson(json['roasting_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.roastingInfo != null) {
      data['roasting_info'] = this.roastingInfo!.toJson();
    }
    return data;
  }
}

class RoastingInfo {
  String? id;
  String? rosterName;
  String? rosterCode;
  String? dutyHour;
  String? startTime;
  String? endTime;
  String? startHour;
  String? startMin;
  String? startAmpm;
  String? endHour;
  String? endMin;
  String? endAmpm;
  String? includeMealBreak;
  String? note;
  String? status;
  String? uploaderInfo;
  String? data;
  String? dateFilter;
  String? createdAt;
  String? updatedAt;

  RoastingInfo(
      {this.id,
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
        this.note,
        this.status,
        this.uploaderInfo,
        this.data,
        this.dateFilter,
        this.createdAt,
        this.updatedAt});

  RoastingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
