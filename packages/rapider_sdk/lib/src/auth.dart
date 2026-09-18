abstract class RapiderAuthSDK {
  Future<String?> getToken();
  Future<Map<String, dynamic>?> getUser();
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<void> clearToken();
  
  // Requirement from feedback: Workspace selector
  Future<List<Map<String, dynamic>>> getWorkspaces();
  Future<void> selectWorkspace(String workspaceId);
  String? get currentWorkspaceId;
}
