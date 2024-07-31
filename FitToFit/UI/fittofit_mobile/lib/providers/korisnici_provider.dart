import 'package:fittofit_mobile/models/korisnici.dart';

import 'base_provider.dart';

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");
  int? _loggedInUserId;
  int? get loggedInUserId => _loggedInUserId;

  @override
  Korisnici fromJson(data) {
    return Korisnici.fromJson(data);
  }

  int? currentUserId;

  void setCurrentUserId(int? userId) {
    currentUserId = userId;

    notifyListeners();
  }

  Future<void> updateUser() async {
    if (currentUserId != null) {
      final updatedUser = await getById(currentUserId!);

      if (updatedUser != null) {
        notifyListeners();
      }
    }
  }
}
