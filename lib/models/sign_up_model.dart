import 'package:json_annotation/json_annotation.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel {
  final String? message;
  final bool? status;
  final SignUpDataModel? data;

  SignUpModel({
    this.message,
    this.status,
    this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => _$SignUpModelFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}

@JsonSerializable()
class SignUpDataModel {
  int? id;
  String? CountryCode;
  String? PhoneNumber;
  String? DeviceId;
  String? Otp;

  SignUpDataModel({this.id, this.CountryCode, this.PhoneNumber, this.DeviceId, this.Otp});

  factory SignUpDataModel.fromJson(Map<String, dynamic> json) => _$SignUpDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpDataModelToJson(this);
}
