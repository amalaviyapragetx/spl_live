import 'package:json_annotation/json_annotation.dart';

part 'balance_model.g.dart';

@JsonSerializable()
class BalanceModel {
  String? message;
  bool? status;
  BalanceDataModel? data;

  BalanceModel({this.message, this.status, this.data});

  factory BalanceModel.fromJson(Map<String, dynamic> json) => _$BalanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceModelToJson(this);
}

@JsonSerializable()
class BalanceDataModel {
  int? id;
  int? UserId;
  int? Amount;
  bool? IsActive;
  String? createdAt;
  String? updatedAt;

  BalanceDataModel({this.id, this.UserId, this.Amount, this.IsActive, this.createdAt, this.updatedAt});

  factory BalanceDataModel.fromJson(Map<String, dynamic> json) => _$BalanceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceDataModelToJson(this);
}
