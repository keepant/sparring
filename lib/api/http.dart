import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

final baseUrl = "https://api.npoint.io";

Dio dioClient() {
  BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Accept': 'application/json',
    },
  );

  Dio dio = new Dio(options);
  dio.interceptors
      .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);

  return dio;
}

Dio httpClient = dioClient();

Future<Response> bookings() {
  return httpClient.get(
    "/9d63b50c33cb0938625e",
  );
}
