class SensorData {
  String? areaId;
  String? areaName;
  List<Sensors>? sensors;
  String? openingTime;
  String? closingTime;
  int? timezoneMinute;
  int? status;
  String? remark;
  String? imgB64;
  String? param2;

  SensorData({
    this.areaId,
    this.areaName,
    this.sensors,
    this.openingTime,
    this.closingTime,
    this.timezoneMinute,
    this.status,
    this.remark,
    this.imgB64,
    this.param2,
  });

  SensorData.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
    if (json['sensors'] != null) {
      sensors = <Sensors>[];
      json['sensors'].forEach((v) {
        sensors!.add(Sensors.fromJson(v));
      });
    }
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    timezoneMinute = json['timezoneMinute'];
    status = json['status'];
    remark = json['remark'];
    imgB64 = json['imgB64'];
    param2 = json['param2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;

    if (sensors != null) {
      data['sensors'] = sensors!.map((v) => v.toJson()).toList();
    }

    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    data['timezoneMinute'] = timezoneMinute;
    data['status'] = status;
    data['remark'] = remark;

    data['imgB64'] = imgB64;
    data['param2'] = param2;
    return data;
  }
}

class Sensors {
  String? sensorId;
  String? sensorName;

  Sensors({
    this.sensorId,
    this.sensorName,
  });

  Sensors.fromJson(Map<String, dynamic> json) {
    sensorId = json['sensorId'];
    sensorName = json['sensorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensorId'] = sensorId;
    data['sensorName'] = sensorName;

    return data;
  }
}
