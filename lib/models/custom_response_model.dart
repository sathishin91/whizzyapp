// To parse this JSON data, do
//
//     final customResponse = customResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

CustomResponse customResponseFromJson(String str) =>
    CustomResponse.fromJson(json.decode(str));

String customResponseToJson(CustomResponse data) => json.encode(data.toJson());

class CustomResponse extends Equatable {
  const CustomResponse({
    this.error,
    required this.success,
    required this.data,
  });

  final String? error;
  final bool success;
  final dynamic data;

  factory CustomResponse.fromJson(Map<String, dynamic> json) => CustomResponse(
        error: json["message"],
        success: json["status"] == "OK" ? true : false,
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": error,
        "status": success,
        "data": data,
      };

  @override
  List<Object?> get props => [success, data, error];
}
