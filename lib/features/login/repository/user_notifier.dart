import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/features/login/data/user.dart';

class UserNotifier extends AsyncNotifier<User> {
  @override
  User build() {
    return User(id: "");
  }

  Future<void> makeLogin() async {}
}
