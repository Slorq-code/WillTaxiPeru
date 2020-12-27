import 'package:injectable/injectable.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/models/user_model.dart';

@lazySingleton
class AppService with ReactiveServiceMixin {
  final RxValue<UserModel> _user = RxValue<UserModel>();
  UserModel get user => _user.value;

  AppService() {
    listenToReactiveValues([_user]);
  }

  void updateUser(UserModel user) => _user.value = user;
}
