import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'host.dart';

// POC: Import a specific page for testing
import 'package:dashboard/dashboard.dart';

void main() {
  // In a real pipeline, the target page is injected during build.
  final rapider = RapiderWebSDK();
  final pageDef = DashboardPageDefinition();

  runApp(
    RapiderPageHost(
      sdk: rapider,
      page: pageDef,
    ),
  );
}
