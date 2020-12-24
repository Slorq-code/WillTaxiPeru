import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taxiapp/app/router.gr.dart' as auto_router;
import 'package:taxiapp/localization/localization_helper.dart';
import 'package:taxiapp/services/api.dart';
import 'package:taxiapp/services/token.dart';

import 'locator.dart';

class Initialize {
  final Token _token = locator<Token>();
  final Api _api = locator<Api>();

  void setPage(String home) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    var delegate = await LocalizationHelper.delegate;
    runApp(LocalizedApp(delegate, _MyApp(home: home)));
  }

  Initialize() {
    _token.hasToken().then(
      (tokenResponse) {
        print('tokenResponse: ' + tokenResponse.toString());
        if (tokenResponse == true) {
          _api.inSessionUser().then((response) {
            setPage(auto_router.Routes.principalViewRoute);
          }).catchError((error) {
            print('entro catch');
            _token.deleteToken();
            setPage(auto_router.Routes.loginViewRoute);
          });
        } else {
          setPage(auto_router.Routes.loginViewRoute);
        }
      },
    );
  }
}

class _MyApp extends StatelessWidget {
  const _MyApp({
    Key key,
    @required this.home,
  }) : super(key: key);
  final String home;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: OverlaySupport(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            builder: ExtendedNavigator.builder(
              router: auto_router.Router(),
              initialRoute: home,
              builder: (context, extendedNav) => Theme(
                  data: ThemeData(
                    fontFamily: 'WhyteTrial',
                    primaryColor: const Color(0xFF2f3640),
                    accentColor: const Color(0xFF353b48),
                  ),
                  child: extendedNav),
            ),
            supportedLocales: localizationDelegate.supportedLocales,
            // locale: localizationDelegate.currentLocale,
            locale: const Locale('es'),
          ),
        ));
  }
}
