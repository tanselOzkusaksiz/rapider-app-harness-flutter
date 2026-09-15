import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'package:rapider_page_contract/rapider_page_contract.dart';
import 'package:rapider_ui/rapider_ui.dart';

class CustomersPageDefinition implements RapiderPageDefinition {
  @override
  String get name => 'customers';

  @override
  String get version => '1.0.0';

  @override
  Widget build(
    BuildContext context,
    RapiderSDK rapider,
    Map<String, dynamic> parameters,
  ) {
    return CustomersPage(rapider: rapider);
  }
}

class CustomersPage extends StatefulWidget {
  final RapiderSDK rapider;

  const CustomersPage({super.key, required this.rapider});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<dynamic> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final res = await widget.rapider.data.list(model: 'CrmAccount', query: {'isDeleted': false});
      if (res.isSuccess && res.data != null) {
        customers = res.data as List;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        leading: BackButton(
          onPressed: () => widget.rapider.navigation.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RapiderDataGrid(
          columns: const ['Name', 'Industry', 'Revenue'],
          rows: customers.map((c) => [
            c['name']?.toString() ?? '',
            c['industry']?.toString() ?? '',
            c['revenue']?.toString() ?? '',
          ]).toList(),
          onRowTap: (index) {
            final customerId = customers[index]['id'];
            widget.rapider.navigation.navigate('customer-detail', params: {'id': customerId});
          },
        ),
      ),
    );
  }
}
