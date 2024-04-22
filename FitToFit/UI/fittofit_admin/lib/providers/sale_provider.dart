import 'package:fittofit_admin/models/sale.dart';

import 'base_provider.dart';

class SaleProvider extends BaseProvider<Sale>
{
  SaleProvider() : super("Sale");
  
  @override
  Sale fromJson(data) {
  return Sale.fromJson(data);
  }
}