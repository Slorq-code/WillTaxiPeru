import 'package:auto_route/auto_route_annotations.dart';
import 'package:taxiapp/ui/views/login/login_view.dart';
import 'package:taxiapp/ui/views/registro_redsocial/registro_redsocial_view.dart';
import 'package:taxiapp/ui/views/welcome/welcome_view.dart';
import 'package:taxiapp/ui/views/registro/registro_view.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AdaptiveRoute(page: WelcomeView, initial: true, name: 'welcomeViewRoute'),
  AdaptiveRoute(page: LoginView, name: 'loginViewRoute'),
  AdaptiveRoute(page: RegistroView, name: 'registroViewRoute'),
  AdaptiveRoute(page: RegistroRedsocialView, name: 'registroRedsocialViewRoute'),
])
class $Router {}
