import 'package:hive_flutter/hive_flutter.dart';

import 'api_response.dart';

class ApiResponseAdapter extends TypeAdapter<ApiResponse> {
  @override
  final int typeId = 1;

  @override
  ApiResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiResponse(
      status: fields[1] as int,
      expiryDate: fields[2] as String?,
      maxLaunch: fields[3] as int?,
      message: fields[4] as String?,
      developerDetails: (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApiResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.expiryDate)
      ..writeByte(3)
      ..write(obj.maxLaunch)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.developerDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiResponseAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
