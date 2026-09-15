import 'package:rapider_page_contract/rapider_page_contract.dart';
import 'package:dashboard/dashboard.dart';
import 'package:customers/customers.dart';
import 'package:customer_detail/customer_detail.dart';

final Map<String, RapiderPageDefinition> pageRegistry = {
  'dashboard': DashboardPageDefinition(),
  'customers': CustomersPageDefinition(),
  'customer-detail': CustomerDetailPageDefinition(),
};
