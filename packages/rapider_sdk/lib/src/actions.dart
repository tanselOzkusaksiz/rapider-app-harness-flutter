class RapiderActionResult {
  final dynamic data;
  final String? error;
  
  RapiderActionResult({this.data, this.error});
  bool get isSuccess => error == null;
}

abstract class RapiderActionSDK {
  Future<RapiderActionResult> execute(String actionName, {Map<String, dynamic>? payload});
}
