abstract class RapiderAuthSDK {
  Future<String?> getToken();
  Future<Map<String, dynamic>?> getUser();
  Future<void> logout();
  
  // Requirement from feedback: Workspace selector
  Future<List<Map<String, dynamic>>> getWorkspaces();
  Future<void> selectWorkspace(String workspaceId);
  String? get currentWorkspaceId;
}
