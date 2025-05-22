class OTPModel {
  var status;
  var code;
  var phone;
  var otp;
  var message;

  OTPModel({this.status, this.code, this.phone, this.otp, this.message});

  OTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    phone = json['phone'];
    otp = json['otp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['message'] = this.message;
    return data;
  }
}
