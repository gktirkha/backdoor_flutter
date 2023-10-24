import 'package:dio/dio.dart';

import 'api_response.dart';

typedef OnPaid = void Function();
typedef OnUnpaid = void Function(ApiResponse? apiResponse);
typedef OnNetworkException = void Function(DioException exception);
typedef OnException = void Function(Object exception);
typedef OnCounter = void Function({num? remainingCounter, String? expiryDate, ApiResponse? storedResponse});
