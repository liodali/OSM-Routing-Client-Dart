import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/osrm/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/osrm/road.dart';
import 'package:routing_client_dart/src/routes_services/routing_service.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class OSRMRoutingService extends RoutingService with OSRMHelper {
  OSRMRoutingService({
    String? serverURL,
    super.header,
  }) : super(serverURL: serverURL ?? oSRMServer);
  OSRMRoutingService.dioClient({
    required super.client,
  }) : super.dioClient();

  void setOSRMURLServer({String server = oSRMServer}) {
    dio.options.baseUrl = server;
  }

  Future<OSRMRoad> getOSRMRoad(OSRMRequest request) async {
    final urlOption = request.encodeHeader();
    final response = await dio.get(dio.options.baseUrl + urlOption);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      final road = await switch (request.profile) {
        Profile.route => compute(
            parseRoad,
            ParserRoadComputeArg(
              jsonRoad: responseJson,
              langCode: request.languages.code,
              alternative: request.hasAlternative ?? false,
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
      final instructions = await buildInstructions(
        road,
        language: request.languages,
      );
      return road.copyWith(
        instructions: instructions,
      );
    } else {
      return OSRMRoad.withError();
    }
  }
}
