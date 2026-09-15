import 'package:flutter/widgets.dart';
import 'package:rapider_sdk/rapider_sdk.dart';

abstract class RapiderPageDefinition {
  String get name;
  String get version;

  Widget build(
    BuildContext context,
    RapiderSDK rapider,
    Map<String, dynamic> parameters,
  );
}
