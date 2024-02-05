import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  String? message;
  bool? status;
  List<BannerDataModel>? data;

  BannerModel({this.message, this.status, this.data});

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class BannerDataModel {
  num? id;
  String? banner;
  String? key;
  bool? isActive;
  num? priority;
  String? createdAt;
  String? updatedAt;

  BannerDataModel({this.id, this.banner, this.key, this.isActive, this.priority, this.createdAt, this.updatedAt});

  factory BannerDataModel.fromJson(Map<String, dynamic> json) => _$BannerDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerDataModelToJson(this);
}
