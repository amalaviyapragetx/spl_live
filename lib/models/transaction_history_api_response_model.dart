class TransactionHistoryApiResponseModel {
  String? message;
  bool? status;
  List<TransactionData>? data;

  TransactionHistoryApiResponseModel({this.message, this.status, this.data});

  TransactionHistoryApiResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  String? bidType;
  String? bidNo;
  int? coins;
  int? balance;
  String? bidTime;
  String? gameMode;
  String? marketName;
  String? openTime;
  String? closeTime;
  bool? isWin;

  TransactionData(
      {this.bidType,
        this.bidNo,
        this.coins,
        this.balance,
        this.bidTime,
        this.gameMode,
        this.marketName,
        this.openTime,
        this.closeTime,
        this.isWin});

  TransactionData.fromJson(Map<String, dynamic> json) {
    bidType = json['BidType'];
    bidNo = json['BidNo'];
    coins = json['Coins'];
    balance = json['Balance'];
    bidTime = json['BidTime'];
    gameMode = json['GameMode'];
    marketName = json['MarketName'];
    openTime = json['OpenTime'];
    closeTime = json['CloseTime'];
    isWin = json['IsWin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BidType'] = bidType;
    data['BidNo'] = bidNo;
    data['Coins'] = coins;
    data['Balance'] = balance;
    data['BidTime'] = bidTime;
    data['GameMode'] = gameMode;
    data['MarketName'] = marketName;
    data['OpenTime'] = openTime;
    data['CloseTime'] = closeTime;
    data['IsWin'] = isWin;
    return data;
  }
}
