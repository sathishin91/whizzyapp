class ApiConstants {
  ApiConstants._();

  static String portNumber = "";

  static bool mockValue = false;

  static const String serverInfo =
      'https://us-central1-mustering-system.cloudfunctions.net/getServerInfo';

  static String loginApp = "/api/User/loginapp";

  static String areaListDropdown = "/api/area/list/dashboard/";

  static String dashboardSensorList = "/api/data/m/area/";

  static String sensorList =
      "/api/area/"; //5487C344-00CC-4020-9A46-CF249395908D/detail

  static String reportSensorList = "/api/data/m/sensor/dataList/area/";
  // "${ApiConstants.reportSensorList}76d2c0fd-e29f-4b1c-9753-0c7ee7f5fe10/20231201090000/20231201225959/timezoneMinute/480/frequencyMinute/60",

  //notification all
  static String notificationAll = "/api/pushnotilog/notification/listall/";

  static String notificationSingle = "/api/pushnotilog/notification/list/";
}
