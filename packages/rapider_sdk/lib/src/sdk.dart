import 'data.dart';
import 'navigation.dart';
import 'actions.dart';
import 'context.dart';
import 'auth.dart';

abstract class RapiderSDK {
  RapiderDataSDK get data;
  RapiderNavigationSDK get navigation;
  RapiderAuthSDK get auth;
  RapiderActionSDK get actions;
  // RapiderFileSDK get files;
  RapiderContextSDK get context;
}
