/// [ParserRoadComputerArg]
/// this class used to data to parserRoad Compute function
/// that will help to make communication easy,readable,maintainable
class ParserRoadComputeArg {
  final Map<String, dynamic> jsonRoad;
  final String langCode;
  final bool alternative;

  ParserRoadComputeArg({
    required this.jsonRoad,
    required this.langCode,
    this.alternative = false,
  });
}

class ParserTripComputeArg extends ParserRoadComputeArg {
  ParserTripComputeArg({
    required Map<String, dynamic> tripJson,
    required String langCode,
  }) : super(
          jsonRoad: tripJson,
          langCode: langCode,
          alternative: false,
        );
}
