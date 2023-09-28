import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:task/utils/common.dart';

class API {
  Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = " https://stg-zero.propertyproplus.com.au";
    _dio.options.headers['Authorization'] = 'Bearer ${AccessToken.tokenValue}';
    _dio.options.headers['Abp.TenantId'] = '10';
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;
}
