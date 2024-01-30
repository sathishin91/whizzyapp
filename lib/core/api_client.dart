import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/utilities.dart';

class ApiClient {
  ApiClient();

  dynamic postMethod(String path, {Map<dynamic, dynamic>? params}) async {
    final apiUrl = path;

    // Request payload
    // final Map<String, String> requestBody = {
    //   'code': 'AB',
    // };

    // Encode the request payload as JSON
    final jsonBody = jsonEncode(params);
    // Make the HTTP request
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
      print('Response Data: $responseData');
      return (response.body);
      // Access the data from the response
    } else {
      // Print an error message if the request was not successful
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception(response.reasonPhrase);
    }
  }
}
