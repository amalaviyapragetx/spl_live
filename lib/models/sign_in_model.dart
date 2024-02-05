import 'package:json_annotation/json_annotation.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel {
  final String? message;
  final bool? status;
  final SignInDataModel? data;

  SignInModel({
    this.message,
    this.status,
    this.data,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) => _$SignInModelFromJson(json);
  Map<String, dynamic> toJson() => _$SignInModelToJson(this);
}

@JsonSerializable()
class SignInDataModel {
  int? Id;
  String? Token;
  String? Role;
  bool? IsMPinSet;
  bool? IsActive;
  bool? IsVerified;
  bool? IsUserDetailSet;

  SignInDataModel(
      {this.Id, this.Token, this.Role, this.IsMPinSet, this.IsActive, this.IsVerified, this.IsUserDetailSet});

  factory SignInDataModel.fromJson(Map<String, dynamic> json) => _$SignInDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInDataModelToJson(this);
}
