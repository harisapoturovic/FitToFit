import 'package:fittofit_admin/models/vrste_treninga.dart';

import 'base_provider.dart';

class VrsteTreningaProvider extends BaseProvider<VrsteTreninga>
{
  VrsteTreningaProvider() : super("VrsteTreninga");
  
  @override
  VrsteTreninga fromJson(data) {
  return VrsteTreninga.fromJson(data);
  }
}