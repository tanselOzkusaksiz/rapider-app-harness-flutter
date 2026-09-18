import 'sdk.dart';
import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

// Stub for now. Will use dart:html / postMessage in real implementation.
class RapiderWebSDK implements RapiderSDK {
  RapiderWebSDK() {
    auth = _WebMockAuthSDK();
    data = _WebMockDataSDK();
    navigation = _WebMockNavigationSDK();
    actions = _WebMockActionSDK();
    context = _WebMockContextSDK();
  }

  @override
  late final RapiderDataSDK data;

  @override
  late final RapiderNavigationSDK navigation;

  @override
  late final RapiderAuthSDK auth;

  @override
  late final RapiderActionSDK actions;

  @override
  late final RapiderContextSDK context;
}

class _WebMockAuthSDK implements RapiderAuthSDK {
  @override
  Future<String?> getToken() async => 'mock_token';
  @override
  Future<Map<String, dynamic>?> getUser() async => {'id': 'mock_user'};
  @override
  Future<void> login(String email, String password) async {}
  @override
  Future<void> logout() async {}
  @override
  Future<void> clearToken() async {}
  @override
  Future<List<Map<String, dynamic>>> getWorkspaces() async => [];
  @override
  Future<void> selectWorkspace(String workspaceId) async {}
  @override
  String? get currentWorkspaceId => null;
}

class _WebMockDataSDK implements RapiderDataSDK {
  @override
  Future<RapiderResult> list({required String model, Map<String, dynamic>? query}) async => RapiderResult(data: []);
  @override
  Future<RapiderResult> get({required String model, required String id}) async => RapiderResult(data: {});
  @override
  Future<RapiderResult> create({required String model, required Map<String, dynamic> data}) async => RapiderResult(data: {});
  @override
  Future<RapiderResult> update({required String model, required String id, required Map<String, dynamic> data}) async => RapiderResult(data: {});
  @override
  Future<RapiderResult> delete({required String model, required String id}) async => RapiderResult(data: {});
}

class _WebMockNavigationSDK implements RapiderNavigationSDK {
  @override
  void navigate(String pageName, {Map<String, dynamic>? params}) {}
  @override
  void back() {}
}

class _WebMockActionSDK implements RapiderActionSDK {
  @override
  Future<RapiderActionResult> execute(String actionName, {Map<String, dynamic>? payload}) async => RapiderActionResult(data: {});
}

class _WebMockContextSDK implements RapiderContextSDK {
  @override
  String get projectId => 'mock_project';
  @override
  String get environment => 'mock_env';
  @override
  Map<String, dynamic> get pageParameters => {};
  @override
  dynamic get(String key) => null;
}
