class SignOutModel {
  String? error;
  String? totalFound;
  bool? valid;
  String? message;

  SignOutModel({this.error, this.totalFound, this.valid, this.message});

  SignOutModel.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
    totalFound = json['TotalFound'];
    valid = json['Valid'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Error'] = error;
    data['TotalFound'] = totalFound;
    data['Valid'] = valid;
    data['Message'] = message;
    return data;
  }
}
