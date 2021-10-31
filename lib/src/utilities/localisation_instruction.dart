class LocalisationInstruction {
  final String languageCode;

  LocalisationInstruction({required this.languageCode})
      : assert(languageCode.isNotEmpty),
        assert(languageCodeDirection.containsKey(languageCode),
            "your language is not supported yet,you can contribute to support your language or use en default");

  String getInstruction(int direction, String name) {
    Map<int, String> directions = languageCodeDirection[languageCode];
    String instruction = "";
    switch (directions.containsKey(direction)) {
      case true:
        instruction = directions[direction]!;
        switch (name.isEmpty) {
          case true:
            instruction = instruction.replaceAll(RegExp(r"\[.*\]"), "");
            break;
          default:
            instruction = instruction.replaceAll(RegExp(r"\["), "");
            instruction = instruction.replaceAll(RegExp(r"\]"), "");
            instruction = instruction.replaceAll(RegExp(r"\%\s"), name);
            break;
        }
        break;
    }

    return instruction;
  }

  static final Map<String, dynamic> languageCodeDirection = {
    "en": _defaultDirectionEn,
  };

  static final Map<int, String> _defaultDirectionEn = {
    1: "Continue [on %s]",
    6: "Turn Slight right [on %s]",
    7: "Turn right [on %s]",
    8: "Turn sharp right [on %s]",
    12: "U-turn [on %s]",
    5: "Turn sharp left [on %s]",
    4: "Turn left [on %s]",
    3: "Turn slight left [on %s]",
    24: "You have reached a waypoint of your trip [on %s]",
    2: "[Go on %s]",
    27: "Enter roundabout and leave at first exit [on %s]",
    28: "Enter roundabout and leave at second exit [on %s]",
    29: "Enter roundabout and leave at third exit [on %s]",
    30: "Enter roundabout and leave at fourth exit [on %s]",
    31: "Enter roundabout and leave at fifth exit [on %s]",
    32: "Enter roundabout and leave at sixth exit [on %s]",
    33: "Enter roundabout and leave at seventh exit [on %s]",
    34: "Enter roundabout and leave at eighth exit [on %s]",
    17: "Take the ramp on the left [on %s]",
    18: "Take the ramp on the right [on %s]",
    19: "Take the ramp on the ahead [on %s]",
  };
}
