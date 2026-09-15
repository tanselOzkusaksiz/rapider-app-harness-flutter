class RapiderResult {
  final dynamic data;
  final String? error;
  
  RapiderResult({this.data, this.error});
  bool get isSuccess => error == null;
}

abstract class RapiderDataSDK {
  Future<RapiderResult> list({required String model, Map<String, dynamic>? query});
  Future<RapiderResult> get({required String model, required String id});
  Future<RapiderResult> create({required String model, required Map<String, dynamic> data});
  Future<RapiderResult> update({required String model, required String id, required Map<String, dynamic> data});
  Future<RapiderResult> delete({required String model, required String id});
}
