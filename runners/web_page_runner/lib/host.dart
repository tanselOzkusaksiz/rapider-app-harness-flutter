import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'package:rapider_page_contract/rapider_page_contract.dart';

class RapiderPageHost extends StatelessWidget {
  final RapiderSDK sdk;
  final RapiderPageDefinition page;
  final Map<String, dynamic> parameters;

  const RapiderPageHost({
    super.key,
    required this.sdk,
    required this.page,
    this.parameters = const {},
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapider Page - ${page.name}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: page.build(context, sdk, parameters),
      ),
    );
  }
}
