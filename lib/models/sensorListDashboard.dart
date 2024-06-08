class DashboardSensorList {
  String? areaId;
  String? areaName;
  String? entryTotalLastweek;
  String? entryTotalCurrentweek;
  String? exitTotalLastweek;
  String? exitTotalCurrentweek;
  String? peakHourLastweek;
  String? peakHourCurrentweek;
  String? avgDwellTime;
  String? maxDwellTime;
  List<HourlyEntry>? hourlyEntry;
  List<HourlyEntry>? hourlyExit;
  List<HourlyEntry>? hourlyOccupancy;

  DashboardSensorList(
      {this.areaId,
      this.areaName,
      this.entryTotalLastweek,
      this.entryTotalCurrentweek,
      this.exitTotalLastweek,
      this.exitTotalCurrentweek,
      this.peakHourLastweek,
      this.peakHourCurrentweek,
      this.avgDwellTime,
      this.maxDwellTime,
      this.hourlyEntry,
      this.hourlyExit,
      this.hourlyOccupancy});

  DashboardSensorList.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
    entryTotalLastweek = json['entryTotal_lastweek'];
    entryTotalCurrentweek = json['entryTotal'];
    exitTotalLastweek = json['exitTotal_lastweek'];
    exitTotalCurrentweek = json['exitTotal'];
    peakHourLastweek = json['peakHour_lastweek'];
    peakHourCurrentweek = json['peakHour'];
    avgDwellTime = json['avgDwellTime'];
    maxDwellTime = json['maxDwellTime'];
    if (json['hourly_entry'] != null) {
      hourlyEntry = <HourlyEntry>[];
      json['hourly_entry'].forEach((v) {
        hourlyEntry!.add(HourlyEntry.fromJson(v));
      });
    }
    if (json['hourly_exit'] != null) {
      hourlyExit = <HourlyEntry>[];
      json['hourly_exit'].forEach((v) {
        hourlyExit!.add(HourlyEntry.fromJson(v));
      });
    }
    if (json['hourly_occupancy'] != null) {
      hourlyOccupancy = <HourlyEntry>[];
      json['hourly_occupancy'].forEach((v) {
        hourlyOccupancy!.add(HourlyEntry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    data['entryTotal_lastweek'] = entryTotalLastweek;
    data['exitTotal_lastweek'] = exitTotalLastweek;
    data['peakHour_lastweek'] = peakHourLastweek;
    data['avgDwellTime'] = avgDwellTime;
    data['maxDwellTime'] = maxDwellTime;
    if (hourlyEntry != null) {
      data['hourly_entry'] = hourlyEntry!.map((v) => v.toJson()).toList();
    }
    if (hourlyExit != null) {
      data['hourly_exit'] = hourlyExit!.map((v) => v.toJson()).toList();
    }
    if (hourlyOccupancy != null) {
      data['hourly_occupancy'] =
          hourlyOccupancy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HourlyEntry {
  String? hour;
  int? inValue;
  int? outValue;

  HourlyEntry({this.hour, this.inValue, this.outValue});

  HourlyEntry.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    inValue = json['inValue'];
    outValue = json['outValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hour'] = hour;
    data['inValue'] = inValue;
    data['outValue'] = outValue;
    return data;
  }
}

class OccupancyData {
  String? areaId;
  String? areaName;
  String? occupancy;

  OccupancyData({this.areaId, this.areaName, this.occupancy});

  OccupancyData.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
    occupancy = json['occupancy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    data['occupancy'] = occupancy;
    return data;
  }
}
