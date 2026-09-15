import 'sdk.dart';
import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

// Stub for now.
class RapiderMobileSDK implements RapiderSDK {
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
