import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/road.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

mixin OSRMRoutingService {
  final dio = Dio(
    BaseOptions(
      baseUrl: oSRMServer,
    ),
  );

  void setOSRMURLServer({String server = oSRMServer}) {
    dio.options.baseUrl = server;
  }

  Future<Road> getOSRMRoad(OSRMRequest request) async {
    final urlOption = request.encodeHeader();
    final response = await dio.get(urlOption);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      return switch (request.profile) {
        Profile.route => compute(
            parseRoad,
            ParserRoadComputeArg(
              jsonRoad: responseJson,
              langCode: request.languages.code,
            ),
          ),
        Profile.trip => compute(
            parseTrip,
            ParserTripComputeArg(
              tripJson: responseJson,
              langCode: request.languages.code,
            ),
          ),
      };
    } else {
      return Road.withError();
    }
  }
}
