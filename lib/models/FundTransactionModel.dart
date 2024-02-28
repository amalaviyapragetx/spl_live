/// message : ""
/// status : true
/// data : {"count":23,"rows":[{"id":26,"UserId":2,"ClientRefId":"1708407655444949325","OrderId":"1002405105400555760","Amount":1,"Status":"Ok","PaymentMode":"UPI","createdAt":"2024-02-20T05:40:56.314Z"},{"id":25,"UserId":2,"ClientRefId":"1708407342459805141","OrderId":"1002405105350425708","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:35:43.679Z"},{"id":24,"UserId":2,"ClientRefId":"1708407326764223038","OrderId":"1002405105350265704","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:35:27.649Z"},{"id":23,"UserId":2,"ClientRefId":"1708407273152514621","OrderId":"1002405105340335698","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:34:34.038Z"},{"id":22,"UserId":2,"ClientRefId":"17084064921541804","OrderId":"1002405105210325616","Amount":100,"Status":"F","PaymentMode":"UPI","createdAt":"2024-02-20T05:21:32.996Z"},{"id":21,"UserId":2,"ClientRefId":"1708406467667945343","OrderId":"1002405105210075615","Amount":100,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:21:08.727Z"},{"id":20,"UserId":2,"ClientRefId":"1708406143769383335","OrderId":"1002405105150435613","Amount":500,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:15:44.696Z"},{"id":19,"UserId":2,"ClientRefId":"1708406139702351370","OrderId":"1002405105150395612","Amount":500,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:15:40.702Z"},{"id":18,"UserId":2,"ClientRefId":"1708405909130540528","OrderId":"1002405105110495611","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:11:49.993Z"},{"id":17,"UserId":2,"ClientRefId":"1708405906470185779","OrderId":"1002405105110465610","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:11:47.377Z"}]}

class FundTransactionModel {
  FundTransactionModel({
    String? message,
    bool? status,
    FundTransactionData? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  FundTransactionModel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _data = json['data'] != null ? FundTransactionData.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _status;
  FundTransactionData? _data;
  FundTransactionModel copyWith({
    String? message,
    bool? status,
    FundTransactionData? data,
  }) =>
      FundTransactionModel(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  FundTransactionData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// count : 23
/// rows : [{"id":26,"UserId":2,"ClientRefId":"1708407655444949325","OrderId":"1002405105400555760","Amount":1,"Status":"Ok","PaymentMode":"UPI","createdAt":"2024-02-20T05:40:56.314Z"},{"id":25,"UserId":2,"ClientRefId":"1708407342459805141","OrderId":"1002405105350425708","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:35:43.679Z"},{"id":24,"UserId":2,"ClientRefId":"1708407326764223038","OrderId":"1002405105350265704","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:35:27.649Z"},{"id":23,"UserId":2,"ClientRefId":"1708407273152514621","OrderId":"1002405105340335698","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:34:34.038Z"},{"id":22,"UserId":2,"ClientRefId":"17084064921541804","OrderId":"1002405105210325616","Amount":100,"Status":"F","PaymentMode":"UPI","createdAt":"2024-02-20T05:21:32.996Z"},{"id":21,"UserId":2,"ClientRefId":"1708406467667945343","OrderId":"1002405105210075615","Amount":100,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:21:08.727Z"},{"id":20,"UserId":2,"ClientRefId":"1708406143769383335","OrderId":"1002405105150435613","Amount":500,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:15:44.696Z"},{"id":19,"UserId":2,"ClientRefId":"1708406139702351370","OrderId":"1002405105150395612","Amount":500,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:15:40.702Z"},{"id":18,"UserId":2,"ClientRefId":"1708405909130540528","OrderId":"1002405105110495611","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:11:49.993Z"},{"id":17,"UserId":2,"ClientRefId":"1708405906470185779","OrderId":"1002405105110465610","Amount":1,"Status":"Pending","PaymentMode":"UPI","createdAt":"2024-02-20T05:11:47.377Z"}]

class FundTransactionData {
  FundTransactionData({
    num? count,
    List<FundTransactionList>? rows,
  }) {
    _count = count;
    _rows = rows;
  }

  FundTransactionData.fromJson(dynamic json) {
    _count = json['count'];
    if (json['rows'] != null) {
      _rows = [];
      json['rows'].forEach((v) {
        _rows?.add(FundTransactionList.fromJson(v));
      });
    }
  }
  num? _count;
  List<FundTransactionList>? _rows;
  FundTransactionData copyWith({
    num? count,
    List<FundTransactionList>? rows,
  }) =>
      FundTransactionData(
        count: count ?? _count,
        rows: rows ?? _rows,
      );
  num? get count => _count;
  List<FundTransactionList>? get rows => _rows;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    if (_rows != null) {
      map['rows'] = _rows?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 26
/// UserId : 2
/// ClientRefId : "1708407655444949325"
/// OrderId : "1002405105400555760"
/// Amount : 1
/// Status : "Ok"
/// PaymentMode : "UPI"
/// createdAt : "2024-02-20T05:40:56.314Z"

class FundTransactionList {
  FundTransactionList(
      {num? id,
      num? userId,
      String? clientRefId,
      String? orderId,
      num? amount,
      String? status,
      String? paymentMode,
      String? createdAt,
      bool? isRead}) {
    _id = id;
    _userId = userId;
    _clientRefId = clientRefId;
    _orderId = orderId;
    _amount = amount;
    _status = status;
    _paymentMode = paymentMode;
    _createdAt = createdAt;
    _isRead = isRead;
  }

  FundTransactionList.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['UserId'];
    _clientRefId = json['ClientRefId'];
    _orderId = json['OrderId'];
    _amount = json['Amount'];
    _status = json['Status'];
    _paymentMode = json['PaymentMode'];
    _createdAt = json['createdAt'];
    _isRead = json['IsRead'];
  }
  num? _id;
  num? _userId;
  String? _clientRefId;
  String? _orderId;
  num? _amount;
  String? _status;
  String? _paymentMode;
  String? _createdAt;
  bool? _isRead;
  FundTransactionList copyWith({
    num? id,
    num? userId,
    String? clientRefId,
    String? orderId,
    num? amount,
    String? status,
    String? paymentMode,
    String? createdAt,
    bool? isRead,
  }) =>
      FundTransactionList(
        id: id ?? _id,
        userId: userId ?? _userId,
        clientRefId: clientRefId ?? _clientRefId,
        orderId: orderId ?? _orderId,
        amount: amount ?? _amount,
        status: status ?? _status,
        paymentMode: paymentMode ?? _paymentMode,
        createdAt: createdAt ?? _createdAt,
        isRead: isRead ?? _isRead,
      );
  num? get id => _id;
  num? get userId => _userId;
  String? get clientRefId => _clientRefId;
  String? get orderId => _orderId;
  num? get amount => _amount;
  String? get status => _status;
  String? get paymentMode => _paymentMode;
  String? get createdAt => _createdAt;
  bool? get isRead => _isRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserId'] = _userId;
    map['ClientRefId'] = _clientRefId;
    map['OrderId'] = _orderId;
    map['Amount'] = _amount;
    map['Status'] = _status;
    map['PaymentMode'] = _paymentMode;
    map['createdAt'] = _createdAt;
    map['IsRead'] = _isRead;
    return map;
  }
}
