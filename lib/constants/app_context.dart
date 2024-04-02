import 'package:WHIZZYPCS/models/sensorModel.dart';

import '../models/dropdown_model.dart';
import '../models/sensorListDashboard.dart';

class AppContext {
  AppContext._privateConstructor();

  static final AppContext _instance = AppContext._privateConstructor();

  factory AppContext() => _instance;

  String baseUrl = "";

  List<ListDropdown> listDropdown = [];
  List<ActiveSensorData> activeSensorData = [];
  // DashboardSensorList sensorListData;
  List<HourlyEntry> hourlyEntry = [];
  List<HourlyEntry> hourlyExit = [];
  List<HourlyEntry> hourlyOccupancy = [];
}
