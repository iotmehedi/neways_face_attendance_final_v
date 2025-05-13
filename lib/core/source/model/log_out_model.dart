class SignOutModel {
  var error;
  var totalFound;
  var valid;
  var message;

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
