import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/models/userModel.dart';

@lazySingleton
class UserService with ReactiveServiceMixin {
  final RxValue<UserModel> _user = RxValue<UserModel>();
  UserModel get counter => _user.value;

  UserService() {
    listenToReactiveValues([_user]);
  }

  void updateUser(UserModel user) {
    _user.value = user;
  }
}
