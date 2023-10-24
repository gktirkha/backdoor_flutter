import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class ApiResponse {
  ApiResponse({
    required this.status,
    this.expiryDate,
    this.maxLaunch,
    this.message,
    this.developerDetails,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      status: (map['status'] != null) ? map['status'] : int.parse(map['status']),
      expiryDate: map['expiryDate'],
      maxLaunch: (map['maxLaunch'] == null) ? null : int.tryParse(map['maxLaunch']),
      message: map['message'],
      developerDetails: map['developerDetails'],
    );
  }

  factory ApiResponse.fromJson(String source) => ApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @HiveField(1)
  final int status;
  @HiveField(2)
  final String? expiryDate;
  @HiveField(3)
  final int? maxLaunch;
  @HiveField(4)
  final String? message;
  @HiveField(5)
  final Map<String, dynamic>? developerDetails;

  ApiResponse copyWith({
    int? status,
    String? expiryDate,
    int? maxLaunch,
    String? message,
    Map<String, dynamic>? developerDetails,
  }) {
    return ApiResponse(
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      maxLaunch: maxLaunch ?? this.maxLaunch,
      message: message ?? this.message,
      developerDetails: developerDetails ?? this.developerDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'expiryDate': expiryDate,
      'maxLaunch': maxLaunch,
      'message': message,
      'developerDetails': developerDetails,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ApiResponse(status: $status, expiryDate: $expiryDate, maxLaunch: $maxLaunch, message: $message, developerDetails: $developerDetails)';
  }

  @override
  bool operator ==(covariant ApiResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.expiryDate == expiryDate && other.maxLaunch == maxLaunch && other.message == message && mapEquals(other.developerDetails, developerDetails);
  }

  @override
  int get hashCode {
    return status.hashCode ^ expiryDate.hashCode ^ maxLaunch.hashCode ^ message.hashCode ^ developerDetails.hashCode;
  }
}
