import 'package:dio/dio.dart';

class DioSingleton {
  DioSingleton._privateConstructor();

  static DioSingleton? _instance;
  static DioSingleton get instance => _instance ??= DioSingleton._privateConstructor();

  static Dio? _dioClient;
  Dio get dioClient => _dioClient ??= Dio();

  void close() {
    _dioClient?.close();
    _dioClient = null;
  }
}
