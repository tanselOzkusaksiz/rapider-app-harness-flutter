import 'sdk.dart';
import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

// Stub for now. Will use dart:html / postMessage in real implementation.
class RapiderWebSDK implements RapiderSDK {
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
