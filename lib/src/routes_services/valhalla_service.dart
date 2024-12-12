import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/road.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

mixin ValhallaRoutingService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: osmValhallaServer,
    ),
  );
  setValhallaServer({String server = osmValhallaServer}) {
    _dio.options.baseUrl = server;
  }

  Future<Road> getValhallaRoad(ValhallaRequest request) async {
    final jsonHeaderRequest = request.encodeHeader();
    final response = await _dio.get(osmValhallaServer, queryParameters: {
      'json': jsonHeaderRequest,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      return compute(
        (_) => Road(distance: 0, duration: 0, polylineEncoded: ''),
        null,
      );
    } else {
      return Road.withError();
    }
  }
}
