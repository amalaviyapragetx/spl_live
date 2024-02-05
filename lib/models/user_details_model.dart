import 'package:json_annotation/json_annotation.dart';

part 'user_details_model.g.dart';

@JsonSerializable()
class SetUserDetailsModel {
  final String? message;
  final bool? status;
  final UserDetailsDataModel? data;

  SetUserDetailsModel({
    this.message,
    this.status,
    this.data,
  });

  factory SetUserDetailsModel.fromJson(Map<String, dynamic> json) => _$SetUserDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SetUserDetailsModelToJson(this);
}

@JsonSerializable()
class UserDetailsDataModel {
  final int? Id;
  final String? Token;
  final String? Role;
  final String? UserName;
  final String? FullName;
  final String? PhoneNumber;
  final String? CountryCode;
  final String? DeviceId;
  final String? LoginAt;
  final bool? IsMPinSet;
  final bool? IsActive;
  final bool? IsVerified;
  final bool? IsUserDetailSet;
  UserDetailsDataModel({
    this.Id,
    this.Token,
    this.Role,
    this.UserName,
    this.FullName,
    this.PhoneNumber,
    this.CountryCode,
    this.DeviceId,
    this.LoginAt,
    this.IsMPinSet,
    this.IsActive,
    this.IsVerified,
    this.IsUserDetailSet,
  });
  factory UserDetailsDataModel.fromJson(Map<String, dynamic> json) => _$UserDetailsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsDataModelToJson(this);
}
// {"message":"MPin set successfully","status":true,"data":{"Id":4,"Token":
// ,"Role":"User","UserName":"Ace","FullName":"Ace","PhoneNumber":"1111111111","CountryCode":
// "+91","DeviceId":"UE1A.230829.036","LoginAt":"2023-10-02T10:06:25.636Z",
// "IsActive":true,"IsMPinSet":true,"IsVerified":true,"IsUserDetailSet":true}}
