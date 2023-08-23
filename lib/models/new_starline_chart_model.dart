/// message : ""
/// status : true
/// data : {"Markets":["06:00 pm","07:00 pm","08:00 pm","09:00 pm"],"data":[{"Date":"2023-08-18","Time":[{"06col00spacepm":null},{"07col00spacepm":null},{"08col00spacepm":null},{"09col00spacepm":null}]},{"Date":"2023-08-22","Time":[{"06col00spacepm":null},{"07col00spacepm":123},{"08col00spacepm":null},{"09col00spacepm":null}]},{"Date":"2023-08-23","Time":[{"06col00spacepm":null},{"07col00spacepm":null},{"08col00spacepm":null},{"09col00spacepm":null}]}]}

class NewStarLineChartModel {
  NewStarLineChartModel({
    String? message,
    bool? status,
    StarLineChartData? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  NewStarLineChartModel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _data =
        json['data'] != null ? StarLineChartData.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _status;
  StarLineChartData? _data;
  NewStarLineChartModel copyWith({
    String? message,
    bool? status,
    StarLineChartData? data,
  }) =>
      NewStarLineChartModel(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  StarLineChartData? get data => _data;

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

/// Markets : ["06:00 pm","07:00 pm","08:00 pm","09:00 pm"]
/// data : [{"Date":"2023-08-18","Time":[{"06col00spacepm":null},{"07col00spacepm":null},{"08col00spacepm":null},{"09col00spacepm":null}]},{"Date":"2023-08-22","Time":[{"06col00spacepm":null},{"07col00spacepm":123},{"08col00spacepm":null},{"09col00spacepm":null}]},{"Date":"2023-08-23","Time":[{"06col00spacepm":null},{"07col00spacepm":null},{"08col00spacepm":null},{"09col00spacepm":null}]}]

class StarLineChartData {
  StarLineChartData({
    List<String>? markets,
    List<StarLineChartData>? data,
  }) {
    _markets = markets;
    _data = data;
  }

  StarLineChartData.fromJson(dynamic json) {
    _markets = json['Markets'] != null ? json['Markets'].cast<String>() : [];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(StarLineChartData.fromJson(v));
      });
    }
  }
  List<String>? _markets;
  List<StarLineChartData>? _data;
  StarLineChartData copyWith({
    List<String>? markets,
    List<StarLineChartData>? data,
  }) =>
      StarLineChartData(
        markets: markets ?? _markets,
        data: data ?? _data,
      );
  List<String>? get markets => _markets;
  List<StarLineChartData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Markets'] = _markets;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Date : "2023-08-18"
/// Time : [{"06col00spacepm":null},{"07col00spacepm":null},{"08col00spacepm":null},{"09col00spacepm":null}]

class Data {
  Data({
    String? date,
    List<StarlineChartTime>? time,
  }) {
    _date = date;
    _time = time;
  }

  Data.fromJson(dynamic json) {
    _date = json['Date'];
    if (json['Time'] != null) {
      _time = [];
      json['Time'].forEach((v) {
        _time?.add(StarlineChartTime.fromJson(v));
      });
    }
  }
  String? _date;
  List<StarlineChartTime>? _time;
  Data copyWith({
    String? date,
    List<StarlineChartTime>? time,
  }) =>
      Data(
        date: date ?? _date,
        time: time ?? _time,
      );
  String? get date => _date;
  List<StarlineChartTime>? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Date'] = _date;
    if (_time != null) {
      map['Time'] = _time?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// 06col00spacepm : null

class StarlineChartTime {
  StarlineChartTime({
    dynamic col00spacepm,
  }) {
    _col00spacepm = col00spacepm;
  }

  StarlineChartTime.fromJson(dynamic json) {
    _col00spacepm = json['06col00spacepm'];
  }
  dynamic _col00spacepm;
  StarlineChartTime copyWith({
    dynamic col00spacepm,
  }) =>
      StarlineChartTime(
        col00spacepm: col00spacepm ?? _col00spacepm,
      );
  dynamic get col00spacepm => _col00spacepm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['06col00spacepm'] = _col00spacepm;
    return map;
  }
}
