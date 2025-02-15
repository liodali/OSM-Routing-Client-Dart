abstract class BaseParserComputeArg {
  final Map<String, dynamic> json;

  const BaseParserComputeArg({required this.json});
}

/// [ParserRoadComputeArg]
///
/// this class used to data to parserRoad Compute function
/// that will help to make communication easy,readable,maintainable
class ParserRoadComputeArg extends BaseParserComputeArg {
  final String langCode;
  final bool alternative;

  const ParserRoadComputeArg({
    required super.json,
    required this.langCode,
    this.alternative = false,
  });
}

class ParserTripComputeArg extends ParserRoadComputeArg {
  const ParserTripComputeArg({
    required Map<String, dynamic> tripJson,
    required super.langCode,
  }) : super(json: tripJson, alternative: false);
}
