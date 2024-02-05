import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_model.g.dart';

@JsonSerializable()
class VerifyOtpModel {
  final String? message;
  final bool? status;
  final VerifyOtpDataModel? data;

  VerifyOtpModel({
    this.message,
    this.status,
    this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpModelFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOtpModelToJson(this);
}

@JsonSerializable()
class VerifyOtpDataModel {
  int? Id;
  String? Token;
  bool? IsActive;
  bool? IsVerified;
  bool? IsUserDetailSet;

  VerifyOtpDataModel({this.Id, this.Token, this.IsActive, this.IsVerified, this.IsUserDetailSet});

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDataModelToJson(this);
}
