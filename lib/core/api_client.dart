import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_context.dart';
import '../constants/utilities.dart';

class ApiClient {
  ApiClient();

  dynamic postMethod(String path,
      {Map<dynamic, dynamic>? params, bool enableUrl = false}) async {
    String apiUrl = "";
    if (enableUrl) {
      apiUrl = path;
    } else {
      apiUrl = AppContext().baseUrl + path;
    }
    // Encode the request payload as JSON
    final jsonBody = jsonEncode(params);
    debugLog("apiurl-------- $path");
    debugLog("parmas-------- $params");
    debugLog("apibaseurl--------- ${AppContext().baseUrl}   ======== $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      debugLog('Response Data: $responseData');
      return (response.body);
      // Access the data from the response
    } else {
      // Print an error message if the request was not successful
      debugLog('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic postMethodReport(String path, {required String body}) async {
    final apiUrl = AppContext().baseUrl + path;

    debugLog("Appurl -============-- $path");
    debugLog("jsonbodyjsonBody -============-- $body");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      debugLog('Response Data: $responseData');
      return (response.body);
      // Access the data from the response
    } else {
      // Print an error message if the request was not successful
      debugLog('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception(response.reasonPhrase);
    }
  }
}
