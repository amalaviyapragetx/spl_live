class StarLineGameModesApiResponseModel {
  String? message;
  bool? status;
  StarLineGameModesData? data;

  StarLineGameModesApiResponseModel({this.message, this.status, this.data});

  StarLineGameModesApiResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? StarLineGameModesData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StarLineGameModesData {
  bool? isBidOpen;
  List<StarLineGameMod>? gameMode;

  StarLineGameModesData({this.isBidOpen, this.gameMode});

  StarLineGameModesData.fromJson(Map<String, dynamic> json) {
    isBidOpen = json['IsBidOpen'];
    if (json['GameMode'] != null) {
      gameMode = <StarLineGameMod>[];
      json['GameMode'].forEach((v) {
        gameMode!.add(StarLineGameMod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsBidOpen'] = isBidOpen;
    if (gameMode != null) {
      data['GameMode'] = gameMode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StarLineGameMod {
  int? id;
  String? name;
  String? image;
  bool? isActive;

  StarLineGameMod({this.id, this.name, this.isActive});

  StarLineGameMod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    image = json['Image'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Name'] = name;
    data['Image'] = image;
    data['IsActive'] = isActive;
    return data;
  }
}
