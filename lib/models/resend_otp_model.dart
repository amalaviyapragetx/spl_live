import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_model.g.dart';

@JsonSerializable()
class ResendOtpModel {
  final String? message;
  final bool? status;
  final ResendOtpDataModel? data;

  ResendOtpModel({
    this.message,
    this.status,
    this.data,
  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) => _$ResendOtpModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResendOtpModelToJson(this);
}

@JsonSerializable()
class ResendOtpDataModel {
  ResendOtpDataModel();
  factory ResendOtpDataModel.fromJson(Map<String, dynamic> json) => _$ResendOtpDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpDataModelToJson(this);
}
