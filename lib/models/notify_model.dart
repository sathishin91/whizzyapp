// class Notify {
//   List<NotificationAll>? notifyData;

//   Notify({this.notifyData});

//   Notify.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       notifyData = <NotificationAll>[];
//       json['data'].forEach((v) {
//         notifyData!.add(NotificationAll.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (notifyData != null) {
//       data['data'] = notifyData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class NotificationAll {
  String? alertId;
  String? alertTitle;
  String? areaId;
  String? areaName;
  List<Persons>? persons;
  int? status;
  String? alertType;
  int? alertIndex;
  int? frequencyIndex;
  String? templateCode;

  NotificationAll(
      {this.alertId,
      this.alertTitle,
      this.areaId,
      this.areaName,
      this.persons,
      this.status,
      this.alertType,
      this.alertIndex,
      this.frequencyIndex,
      this.templateCode});

  factory NotificationAll.fromJson(Map<String, dynamic> json) =>
      NotificationAll(
        alertId: json['alertId'],
        alertTitle: json['alertTitle'],
        areaId: json['areaId'],
        areaName: json['areaName'],
        // if (json['persons'] != null) {
        // persons = <Persons>[];
        // json['persons'].forEach((v) {
        //   persons!.add(Persons.fromJson(v));
        // });
        // }
        persons: json['persons'] != null
            ? List<Persons>.from(
                json['persons'].map((x) => Persons.fromJson(x)))
            : [],
        status: json['status'],
        alertType: json['alertType'],
        alertIndex: json['alertIndex'],
        frequencyIndex: json['frequencyIndex'],
        templateCode: json['templateCode'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alertId'] = alertId;
    data['alertTitle'] = alertTitle;
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    if (persons != null) {
      data['persons'] = persons!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['alertType'] = alertType;
    data['alertIndex'] = alertIndex;
    data['frequencyIndex'] = frequencyIndex;
    data['templateCode'] = templateCode;
    return data;
  }
}

class Persons {
  String? email;

  Persons({this.email});

  Persons.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}
