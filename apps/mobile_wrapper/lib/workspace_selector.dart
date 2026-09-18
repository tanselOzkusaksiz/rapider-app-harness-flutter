import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'package:rapider_ui/auth/login_screen.dart';

class WorkspaceSelector extends StatefulWidget {
  final RapiderSDK sdk;
  final Widget child;

  const WorkspaceSelector({super.key, required this.sdk, required this.child});

  @override
  State<WorkspaceSelector> createState() => _WorkspaceSelectorState();
}

class _WorkspaceSelectorState extends State<WorkspaceSelector> {
  bool isLoading = true;
  bool isWorkspaceSelected = false;
  bool isAuthenticated = false;
  List<Map<String, dynamic>> workspaces = [];

  @override
  void initState() {
    super.initState();
    _checkWorkspaces();
  }

  Future<void> _checkWorkspaces() async {
    setState(() => isLoading = true);
    
    final requireLogin = RapiderEnvironment.requireLogin;

    if (requireLogin) {
      final token = await widget.sdk.auth.getToken();
      if (token == null) {
        setState(() {
          isAuthenticated = false;
          isLoading = false;
        });
        return;
      } else {
        isAuthenticated = true;
      }
    } else {
      isAuthenticated = true; // Bypass login
    }

    // Check if we already have a selected workspace
    if (widget.sdk.auth.currentWorkspaceId != null) {
      setState(() {
        isWorkspaceSelected = true;
        isLoading = false;
      });
      return;
    }

    try {
      workspaces = await widget.sdk.auth.getWorkspaces();
      
      if (workspaces.length == 1) {
        // Auto-select if there's only one
        await widget.sdk.auth.selectWorkspace(workspaces.first['id'] as String);
        setState(() {
          isWorkspaceSelected = true;
        });
      }
    } catch (e) {
      // If fetching fails (e.g. token expired), reset token and show login
      if (requireLogin) {
        await widget.sdk.auth.logout();
        isAuthenticated = false;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectWorkspace(String id) async {
    setState(() => isLoading = true);
    await widget.sdk.auth.selectWorkspace(id);
    setState(() {
      isWorkspaceSelected = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Navigator(
        key: const ValueKey('nav_loading'),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    if (!isAuthenticated) {
      return Navigator(
        key: const ValueKey('nav_login'),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => RapiderLoginScreen(
            sdk: widget.sdk,
            onLoginSuccess: _checkWorkspaces,
          ),
        ),
      );
    }

    if (isWorkspaceSelected) {
      return widget.child;
    }

    return Navigator(
      key: const ValueKey('nav_workspaces'),
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Select Workspace')),
          body: ListView.builder(
            itemCount: workspaces.length,
            itemBuilder: (context, index) {
              final ws = workspaces[index];
              return ListTile(
                title: Text(ws['name']?.toString() ?? 'Unknown Workspace'),
                subtitle: Text(ws['id']?.toString() ?? ''),
                onTap: () => _selectWorkspace(ws['id'] as String),
              );
            },
          ),
        ),
      ),
    );
  }
}
