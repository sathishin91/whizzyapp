class ReportModel {
  String? areaId;
  String? areaName;
  List<HourlyValuesRpts>? hourlyValuesRpts;

  ReportModel({this.areaId, this.areaName, this.hourlyValuesRpts});

  ReportModel.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
    if (json['hourlyValuesRpts'] != null) {
      hourlyValuesRpts = <HourlyValuesRpts>[];
      json['hourlyValuesRpts'].forEach((v) {
        hourlyValuesRpts!.add(HourlyValuesRpts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    if (hourlyValuesRpts != null) {
      data['hourlyValuesRpts'] =
          hourlyValuesRpts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HourlyValuesRpts {
  String? sensorUuId;
  String? sensorName;
  String? hour;
  int? inValue;
  int? outValue;
  String? timeStamp;

  HourlyValuesRpts(
      {this.sensorUuId,
      this.sensorName,
      this.hour,
      this.inValue,
      this.outValue,
      this.timeStamp});

  HourlyValuesRpts.fromJson(Map<String, dynamic> json) {
    sensorUuId = json['sensorUuId'];
    sensorName = json['sensorName'];
    hour = json['hour'];
    inValue = json['inValue'];
    outValue = json['outValue'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensorUuId'] = sensorUuId;
    data['sensorName'] = sensorName;
    data['hour'] = hour;
    data['inValue'] = inValue;
    data['outValue'] = outValue;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
