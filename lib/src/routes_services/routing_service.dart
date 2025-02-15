import 'package:dio/dio.dart';

abstract class RoutingService {
  final Dio dio;
  RoutingService({String? serverURL, Map<String, String>? header})
    : dio = Dio(BaseOptions(baseUrl: serverURL ?? '', headers: header));
  RoutingService.dioClient({required Dio client}) : dio = client;
}
