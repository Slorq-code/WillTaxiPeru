import 'package:auto_route/auto_route_annotations.dart';
import 'package:taxiapp/ui/views/login/login_view.dart';
import 'package:taxiapp/ui/views/principal/principal_view.dart';
import 'package:taxiapp/ui/views/register_social_network/register_social_network_view.dart';
import 'package:taxiapp/ui/views/reset_password/reset_password_view.dart';
import 'package:taxiapp/ui/views/welcome/welcome_view.dart';
import 'package:taxiapp/ui/views/register/register_view.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AdaptiveRoute(page: WelcomeView, initial: true, name: 'welcomeViewRoute'),
  AdaptiveRoute(page: LoginView, name: 'loginViewRoute'),
  AdaptiveRoute(page: RegisterView, name: 'registerViewRoute'),
  AdaptiveRoute(page: RegisterSocialNetworkView, name: 'registerSocialNetworkViewRoute'),
  AdaptiveRoute(page: PrincipalView, name: 'principalViewRoute'),
  AdaptiveRoute(page: ResetPasswordView, name: 'resetPasswordViewRoute'),
])
class $Router {}
