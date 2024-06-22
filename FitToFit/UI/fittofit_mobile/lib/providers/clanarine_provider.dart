import 'package:fittofit_admin/models/clanarine.dart';

import 'base_provider.dart';

class ClanarineProvider extends BaseProvider<Clanarine>
{
  ClanarineProvider() : super("Clanarine");
  
  @override
  Clanarine fromJson(data) {
  return Clanarine.fromJson(data);
  }
}