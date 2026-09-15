import 'package:flutter/material.dart';
import 'package:rapider_sdk/rapider_sdk.dart';
import 'package:rapider_page_contract/rapider_page_contract.dart';
import 'package:rapider_ui/rapider_ui.dart';

class DashboardPageDefinition implements RapiderPageDefinition {
  @override
  String get name => 'dashboard';

  @override
  String get version => '1.0.0';

  @override
  Widget build(
    BuildContext context,
    RapiderSDK rapider,
    Map<String, dynamic> parameters,
  ) {
    return DashboardPage(rapider: rapider);
  }
}

class DashboardPage extends StatefulWidget {
  final RapiderSDK rapider;

  const DashboardPage({super.key, required this.rapider});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int pipelineValue = 0;
  int activeLeads = 0;
  int openCases = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Fetch Leads
      final leadsRes = await widget.rapider.data.list(model: 'CrmLead', query: {'isDeleted': false});
      if (leadsRes.isSuccess && leadsRes.data != null) {
        activeLeads = (leadsRes.data as List).length;
      }

      // Fetch Cases
      final casesRes = await widget.rapider.data.list(model: 'CrmCase', query: {'isDeleted': false, 'status': 'Open'});
      if (casesRes.isSuccess && casesRes.data != null) {
        openCases = (casesRes.data as List).length;
      }

      // Fetch Opportunities
      final oppsRes = await widget.rapider.data.list(model: 'CrmOpportunity', query: {'isDeleted': false});
      if (oppsRes.isSuccess && oppsRes.data != null) {
        final opps = oppsRes.data as List;
        pipelineValue = opps
          .where((o) => o['stage'] != 'Closed Lost')
          .fold<int>(0, (sum, o) => sum + (o['amount'] as int? ?? 0));
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
        title: const Text('Dashboard'),
        actions: [
          RapiderButton(
            text: 'New Lead',
            onPressed: () => widget.rapider.navigation.navigate('leads'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RapiderCard(
                    child: Column(
                      children: [
                        const Text('Pipeline Value'),
                        Text('\$${pipelineValue.toString()}'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RapiderCard(
                    child: Column(
                      children: [
                        const Text('Active Leads'),
                        Text(activeLeads.toString()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RapiderCard(
                    child: Column(
                      children: [
                        const Text('Open Cases'),
                        Text(openCases.toString(), style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RapiderButton(
                text: 'View Customers',
                onPressed: () => widget.rapider.navigation.navigate('customers'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
