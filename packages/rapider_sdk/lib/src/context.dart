abstract class RapiderContextSDK {
  String get projectId;
  String get environment;
  Map<String, dynamic> get pageParameters;
  dynamic get(String key);
}
