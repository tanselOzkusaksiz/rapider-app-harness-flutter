import 'sdk.dart';
import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'environment.dart';

class _MobileAuthSDK implements RapiderAuthSDK {
  String? _currentWorkspaceId;
  
  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  @override
  Future<Map<String, dynamic>?> getUser() async {
    // In a real implementation, you might fetch /users/me or decode the JWT
    return {'id': 'current_user'};
  }
  
  @override
  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Step 1: Initial Login
    final loginResponse = await http.post(
      Uri.parse('${RapiderEnvironment.apiUrl}/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );
    
    if (loginResponse.statusCode < 200 || loginResponse.statusCode >= 300) {
      throw Exception('Login failed: ${loginResponse.statusCode} - ${loginResponse.body}');
    }

    final loginData = jsonDecode(loginResponse.body);
    final initialToken = loginData['authenticationToken'] as String?;
    if (initialToken == null) throw Exception('No authentication token received');

    // Step 2: Fetch User and Person info
    final userResponse = await http.get(
      Uri.parse('${RapiderEnvironment.apiUrl}/users/get-user-by-authentication-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': initialToken,
      },
    );

    if (userResponse.statusCode < 200 || userResponse.statusCode >= 300) {
      throw Exception('Failed to fetch user info: ${userResponse.statusCode}');
    }

    final userData = jsonDecode(userResponse.body);
    final people = userData['people'] as List<dynamic>?;
    if (people == null || people.isEmpty) {
      throw Exception('No person associated with this user');
    }

    final personId = people[0]['id'];

    // Step 3: Change Active Person (Swap token)
    final personResponse = await http.post(
      Uri.parse('${RapiderEnvironment.apiUrl}/users/change-active-person'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': initialToken,
      },
      body: jsonEncode({'personId': personId}),
    );

    if (personResponse.statusCode < 200 || personResponse.statusCode >= 300) {
      throw Exception('Failed to set active person: ${personResponse.statusCode}');
    }

    final personData = jsonDecode(personResponse.body);
    final personToken = personData['authenticationToken'] as String?;
    if (personToken == null) throw Exception('No person token received');

    await prefs.setString('auth_token', personToken);
  }

  @override
  Future<void> logout() async {
    await clearToken();
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _currentWorkspaceId = null;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getWorkspaces() async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('${RapiderEnvironment.apiUrl}/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load workspaces: ${response.statusCode}');
    }
  }
  
  @override
  Future<void> selectWorkspace(String workspaceId) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    // Step 5: Change Active Project (Swap token)
    final response = await http.post(
      Uri.parse('${RapiderEnvironment.apiUrl}/users/change-active-project'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'projectId': workspaceId}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      final projectToken = data['authenticationToken'] as String?;
      if (projectToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', projectToken);
      }
      _currentWorkspaceId = workspaceId;
    } else {
      throw Exception('Failed to set active project: ${response.statusCode}');
    }
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
    auth = _MobileAuthSDK();
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
