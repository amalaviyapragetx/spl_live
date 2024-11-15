class StarlineBidRequestModel {
  int? userId;
  int? dailyStarlineMarketId;
  List<StarLineBids>? bids;

  StarlineBidRequestModel({this.userId, this.dailyStarlineMarketId, this.bids});

  StarlineBidRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    dailyStarlineMarketId = json['dailyStarlineMarketId'];
    if (json['bids'] != null) {
      bids = <StarLineBids>[];
      json['bids'].forEach((v) {
        bids!.add(StarLineBids.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['dailyStarlineMarketId'] = dailyStarlineMarketId;
    if (bids != null) {
      data['bids'] = bids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StarLineBids {
  int? starlineGameId;
  String? bidNo;
  int? coins;
  String? remarks;

  StarLineBids({this.starlineGameId, this.bidNo, this.coins, this.remarks});

  StarLineBids.fromJson(Map<String, dynamic> json) {
    starlineGameId = json['starlineGameId'];
    bidNo = json['bidNo'];
    coins = json['coins'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['starlineGameId'] = starlineGameId;
    data['bidNo'] = bidNo;
    data['coins'] = coins;
    data['remarks'] = remarks;
    return data;
  }
}
