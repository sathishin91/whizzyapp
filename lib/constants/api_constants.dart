import 'app_context.dart';

class ApiConstants {
  ApiConstants._();

  String baseUrl = "";
  static String portNumber = "";

  static bool mockValue = false;

  static const String serverInfo =
      'https://us-central1-mustering-system.cloudfunctions.net/getServerInfo';

  static String loginApp = "${AppContext().baseUrl}/api/User/loginapp";

  static String areaListDropdown =
      "${AppContext().baseUrl}/api/area/list/dashboard/";
}
