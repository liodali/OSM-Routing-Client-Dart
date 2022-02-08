/// [ParserRoadComputerArg]
/// this class used to data to parserRoad Compute function
/// that will help to make communication easy,readable,maintainable
class ParserRoadComputerArg {
  final Map<String, dynamic> jsonRoad;
  final String langCode;
  final bool alternative;

  ParserRoadComputerArg({
    required this.jsonRoad,
    required this.langCode,
    this.alternative = false,
  });
}
