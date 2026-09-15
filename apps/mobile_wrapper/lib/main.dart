import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'page_registry.dart';

import 'workspace_selector.dart';

void main() {
  final sdk = RapiderMobileSDK();
  runApp(MobileWrapperApp(sdk: sdk));
}

class MobileWrapperApp extends StatelessWidget {
  final RapiderSDK sdk;
  const MobileWrapperApp({super.key, required this.sdk});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapider Mobile Wrapper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return WorkspaceSelector(
          sdk: sdk,
          child: child ?? const SizedBox(),
        );
      },
      initialRoute: 'dashboard',
      onGenerateRoute: (settings) {
        final pageDef = pageRegistry[settings.name];
        if (pageDef != null) {
          final params = (settings.arguments as Map<String, dynamic>?) ?? {};
          return MaterialPageRoute(
            builder: (context) => pageDef.build(context, sdk, params),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
