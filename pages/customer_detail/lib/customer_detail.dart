import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'package:rapider_page_contract/rapider_page_contract.dart';
import 'package:rapider_ui/rapider_ui.dart';

class CustomerDetailPageDefinition implements RapiderPageDefinition {
  @override
  String get name => 'customer-detail';

  @override
  String get version => '1.0.0';

  @override
  Widget build(
    BuildContext context,
    RapiderSDK rapider,
    Map<String, dynamic> parameters,
  ) {
    return CustomerDetailPage(rapider: rapider, customerId: parameters['id']);
  }
}

class CustomerDetailPage extends StatefulWidget {
  final RapiderSDK rapider;
  final String? customerId;

  const CustomerDetailPage({super.key, required this.rapider, this.customerId});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  Map<String, dynamic>? customer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.customerId == null) {
      setState(() => isLoading = false);
      return;
    }
    
    try {
      final res = await widget.rapider.data.get(model: 'CrmAccount', id: widget.customerId!);
      if (res.isSuccess && res.data != null) {
        customer = res.data as Map<String, dynamic>;
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

    if (customer == null) {
      return const Scaffold(
        body: Center(child: Text('Customer not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customer!['name'] ?? 'Customer Detail'),
        leading: BackButton(
          onPressed: () => widget.rapider.navigation.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RapiderCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${customer!['name']}'),
              Text('Industry: ${customer!['industry']}'),
              Text('Revenue: \$${customer!['revenue']}'),
              Text('Phone: ${customer!['phone']}'),
              Text('Website: ${customer!['website']}'),
              const SizedBox(height: 16),
              RapiderButton(
                text: 'Edit Customer',
                onPressed: () {
                  // Not fully implemented for POC
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
