class EmailVerifyModel {
  String? status;
  String? data;

  EmailVerifyModel({this.status, this.data});

  EmailVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
  }
}