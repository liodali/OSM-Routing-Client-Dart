import 'package:routing_client_dart/src/models/osrm/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/osrm/road.dart';
import 'package:routing_client_dart/src/routes_services/routing_service.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class OSRMRoutingService extends RoutingService with OSRMHelper {
  OSRMRoutingService({String? serverURL, super.header})
    : super(serverURL: serverURL ?? oSRMServer);
  OSRMRoutingService.dioClient({required super.client}) : super.dioClient();

  void setOSRMURLServer({String server = oSRMServer}) {
    dio.options.baseUrl = server;
  }

  Future<OSRMRoad> getOSRMRoad(OSRMRequest request) async {
    final urlOption = request.encodeHeader();
    final response = await dio.get(dio.options.baseUrl + urlOption);
    final Map<String, dynamic> responseJson = Map.from(response.data);
    if (response.statusCode != null && response.statusCode! > 299 ||
        response.statusCode! < 200) {
      return OSRMRoad.withError();
    }
    final instructionsHelper = loadInstructionHelperJson(
      language: request.languages,
    );

    final data = (
      json: responseJson,
      request: request,
      helper: instructionsHelper,
    );
    final route = await switch (data.request.profile) {
      Profile.route => parseRoad(
        ParserRoadComputeArg(
          json: data.json,
          langCode: data.request.languages.code,
          alternative: request.hasAlternative ?? false,
        ),
      ),
      Profile.trip => parseTrip(
        ParserTripComputeArg(
          tripJson: data.json,
          langCode: data.request.languages.code,
        ),
      ),
    };
    final instructions = OSRMHelper.buildInstructions(
      road: route,
      instructionsHelper: data.helper,
    );
    return route.copyWith(instructions: instructions);
  }
}
