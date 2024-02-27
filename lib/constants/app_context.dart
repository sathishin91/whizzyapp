import '../models/dropdown_model.dart';
import '../models/sensorListDashboard.dart';

class AppContext {
  AppContext._privateConstructor();

  static final AppContext _instance = AppContext._privateConstructor();

  factory AppContext() => _instance;

  String baseUrl = "";

  List<ListDropdown> listDropdown = [];
  // DashboardSensorList sensorListData;
  List<HourlyEntry> hourlyEntry = [];
  List<HourlyEntry> hourlyExit = [];
  List<HourlyEntry> hourlyOccupancy = [];
}
