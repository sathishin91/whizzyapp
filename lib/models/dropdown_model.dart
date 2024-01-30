// class ListData {
//   List<ListDropdown> listDropdown = [];

//   ListData({required this.listDropdown});

//   ListData.fromJson(Map<String, dynamic> json) {
//     final jsBannerAry = json['data'];
//     if (jsBannerAry != null) {
//       jsBannerAry.forEach((v) => listDropdown.add(ListDropdown.fromJson(v)));
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['bannerList'] = listDropdown.map((v) => v.toJson()).toList();
//     return data;
//   }
// }

import '../constants/app_context.dart';

class ListDropdown {
  String? areaId;
  String? areaName;
  String? parentArea;
  Client? client;
  String? openingTime;
  String? closingTime;
  int? timezoneMinute;
  int? status;
  String? remark;
  Configs? configs;
  String? imgB64;
  String? token;
  String? param1;
  String? param2;

  ListDropdown({
    this.areaId,
    this.areaName,
    this.parentArea,
    this.client,
    this.openingTime,
    this.closingTime,
    this.timezoneMinute,
    this.status,
    this.remark,
    this.configs,
    this.imgB64,
    this.token,
    this.param1,
    this.param2,
  });

  ListDropdown.fromList(List<dynamic> jsonList) {
    // Assuming your API response has a key 'data' that contains the list of areas
    final List<Map<String, dynamic>> dataList =
        jsonList.cast<Map<String, dynamic>>();

    // Now, you can iterate over the list and create ListDropdown objects
    AppContext().listDropdown =
        dataList.map((json) => ListDropdown.fromJson(json)).toList();
  }

  ListDropdown.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
    parentArea = json['parentArea'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    timezoneMinute = json['timezoneMinute'];
    status = json['status'];
    remark = json['remark'];
    configs =
        json['configs'] != null ? Configs.fromJson(json['configs']) : null;
    imgB64 = json['imgB64'];
    token = json['token'];
    param1 = json['param1'];
    param2 = json['param2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    data['parentArea'] = parentArea;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    data['timezoneMinute'] = timezoneMinute;
    data['status'] = status;
    data['remark'] = remark;
    if (configs != null) {
      data['configs'] = configs!.toJson();
    }
    data['imgB64'] = imgB64;
    data['token'] = token;
    data['param1'] = param1;
    data['param2'] = param2;
    return data;
  }
}

class Client {
  String? clientId;
  String? clientName;
  int? status;
  String? createdOnUtc;

  Client({this.clientId, this.clientName, this.status, this.createdOnUtc});

  Client.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    clientName = json['clientName'];
    status = json['status'];
    createdOnUtc = json['createdOnUtc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['status'] = status;
    data['createdOnUtc'] = createdOnUtc;
    return data;
  }
}

class Configs {
  Configs();

  Configs.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
