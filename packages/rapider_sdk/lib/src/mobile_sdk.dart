import 'sdk.dart';
import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

class _MockAuthSDK implements RapiderAuthSDK {
  String? _currentWorkspaceId;
  
  @override
  Future<String?> getToken() async => 'mock_token';
  
  @override
  Future<Map<String, dynamic>?> getUser() async => {'id': 'mock_user'};
  
  @override
  Future<void> logout() async {}
  
  @override
  Future<List<Map<String, dynamic>>> getWorkspaces() async => [
    {'id': 'ws_1', 'name': 'Default Workspace'},
    {'id': 'ws_2', 'name': 'Secondary Workspace'}
  ];
  
  @override
  Future<void> selectWorkspace(String workspaceId) async {
    _currentWorkspaceId = workspaceId;
  }
  
  @override
  String? get currentWorkspaceId => _currentWorkspaceId;
}

class _MockDataSDK implements RapiderDataSDK {
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

class _MockNavigationSDK implements RapiderNavigationSDK {
  @override
  void navigate(String pageName, {Map<String, dynamic>? params}) {}
  @override
  void back() {}
}

class _MockActionSDK implements RapiderActionSDK {
  @override
  Future<RapiderActionResult> execute(String actionName, {Map<String, dynamic>? payload}) async => RapiderActionResult(data: {});
}

class _MockContextSDK implements RapiderContextSDK {
  @override
  String get projectId => 'mock_project';
  @override
  String get environment => 'mock_env';
  @override
  Map<String, dynamic> get pageParameters => {};
  @override
  dynamic get(String key) => null;
}

// Stub for now.
class RapiderMobileSDK implements RapiderSDK {
  RapiderMobileSDK() {
    auth = _MockAuthSDK();
    data = _MockDataSDK();
    navigation = _MockNavigationSDK();
    actions = _MockActionSDK();
    context = _MockContextSDK();
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
