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

// class SensorActiveList {
//   String? sensorUpDown;
//   String? sensorColor;
//   List<SensorList>? sensorList;

//   SensorActiveList({this.sensorUpDown, this.sensorColor, this.sensorList});

//   SensorActiveList.fromJson(Map<String, dynamic> json) {
//     sensorUpDown = json['sensorUp/Down'];
//     sensorColor = json['sensorColor'];
//     if (json['sensorList'] != null) {
//       sensorList = <SensorList>[];
//       json['sensorList'].forEach((v) {
//         sensorList!.add(SensorList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['sensorUp/Down'] = sensorUpDown;
//     data['sensorColor'] = sensorColor;
//     if (sensorList != null) {
//       data['sensorList'] = sensorList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SensorList {
//   String? sensorId;
//   String? sensorName;
//   String? datetime;

//   SensorList({this.sensorId, this.sensorName, this.datetime});

//   SensorList.fromJson(Map<String, dynamic> json) {
//     sensorId = json['sensorId'];
//     sensorName = json['sensorName'];
//     datetime = json['datetime'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['sensorId'] = sensorId;
//     data['sensorName'] = sensorName;
//     data['datetime'] = datetime;
//     return data;
//   }
// }
// class sensorData {
//   String? status;
//   String? message;
//   List<ActiveSensorData>? data;

//   sensorData({this.status, this.message, this.data});

//   sensorData.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <ActiveSensorData>[];
//       json['data'].forEach((v) {
//         data!.add(ActiveSensorData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class ActiveSensorData {
  double? minutes;
  String? statusColor;
  String? imageTimestampUtc;
  SensorActive? sensor;
  int? inValue;
  int? outValue;
  int? inValueT002;
  int? outValueT002;
  int? inValueT003;
  int? outValueT003;
  String? timestampUtc;
  String? timestamp;

  ActiveSensorData({
    this.minutes,
    this.statusColor,
    this.imageTimestampUtc,
    this.sensor,
    this.inValue,
    this.outValue,
    this.inValueT002,
    this.outValueT002,
    this.inValueT003,
    this.outValueT003,
    this.timestampUtc,
    this.timestamp,
  });

  ActiveSensorData.fromJson(Map<String, dynamic> json) {
    minutes = json['minutes'];
    statusColor = json['statusColor'];
    imageTimestampUtc = json['imageTimestampUtc'];
    sensor =
        json['sensor'] != null ? SensorActive.fromJson(json['sensor']) : null;
    inValue = json['inValue'];
    outValue = json['outValue'];
    inValueT002 = json['inValueT002'];
    outValueT002 = json['outValueT002'];
    inValueT003 = json['inValueT003'];
    outValueT003 = json['outValueT003'];
    timestampUtc = json['timestampUtc'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minutes'] = minutes;
    data['statusColor'] = statusColor;
    data['imageTimestampUtc'] = imageTimestampUtc;
    if (sensor != null) {
      data['sensor'] = sensor!.toJson();
    }
    data['inValue'] = inValue;
    data['outValue'] = outValue;
    data['inValueT002'] = inValueT002;
    data['outValueT002'] = outValueT002;
    data['inValueT003'] = inValueT003;
    data['outValueT003'] = outValueT003;
    data['timestampUtc'] = timestampUtc;
    data['timestamp'] = timestamp;
    return data;
  }
}

class SensorActive {
  String? sensorUuid;
  String? sensorName;
  int? inFlow;
  int? outFlow;
  int? status;
  int? inTune;
  int? outTune;
  String? startTime;
  String? endTime;

  SensorActive(
      {this.sensorUuid,
      this.sensorName,
      this.inFlow,
      this.outFlow,
      this.status,
      this.inTune,
      this.outTune,
      this.startTime,
      this.endTime});

  SensorActive.fromJson(Map<String, dynamic> json) {
    sensorUuid = json['sensorUuid'];
    sensorName = json['sensorName'];
    inFlow = json['inFlow'];
    outFlow = json['outFlow'];
    status = json['status'];
    inTune = json['inTune'];
    outTune = json['outTune'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensorUuid'] = sensorUuid;
    data['sensorName'] = sensorName;
    data['inFlow'] = inFlow;
    data['outFlow'] = outFlow;
    data['status'] = status;
    data['inTune'] = inTune;
    data['outTune'] = outTune;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
