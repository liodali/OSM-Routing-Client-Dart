import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/models/valhalla/valhalla_response.dart';
import 'package:routing_client_dart/src/routes_services/routing_service.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class ValhallaRoutingService extends RoutingService {
  ValhallaRoutingService({
    String? valhallaServer,
    super.header,
  }) : super(
          serverURL: valhallaServer ?? osmValhallaServer,
        );
  ValhallaRoutingService.dioClient({
    required super.client,
  }) : super.dioClient();
  Future<Route> getValhallaRoad(ValhallaRequest request) async {
    final jsonHeaderRequest = request.encodeHeader();
    final response = await dio.get(osmValhallaServer, queryParameters: {
      'json': jsonHeaderRequest,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      final valhallaResp = ValhallaResponse.fromJson(responseJson);
      return compute(
        (_) => valhallaResp.toRoute(),
        null,
      );
    } else {
      throw Exception("cannot get route");
    }
  }
}
