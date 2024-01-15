import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:k3_sipp_mobile/bloc/devices_cubit.dart';
import 'package:k3_sipp_mobile/bloc/menu_cubit.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/ui/assignment/create_assignment_page.dart';
import 'package:k3_sipp_mobile/ui/auth/login_page.dart';
import 'package:k3_sipp_mobile/ui/devices/device_page.dart';
import 'package:k3_sipp_mobile/ui/launcher.dart';
import 'package:k3_sipp_mobile/ui/main/main_menu_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorResources.primaryDark,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuCubit>(create: (context) => MenuCubit()),
        BlocProvider<DevicesCubit>(create: (context) => DevicesCubit()),
      ],
      child: MaterialApp(
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'SIPP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorSchemeSeed: ColorResources.primary,
          scaffoldBackgroundColor: ColorResources.background,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorResources.primaryDark,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontSize: Dimens.fontToolbar,
              fontFamily: "Nunito",
              color: ColorResources.highlight,
            ),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: Dimens.fontSmall, fontFamily: "Nunito", color: ColorResources.text),
            bodyMedium: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "Nunito", color: ColorResources.text),
            bodyLarge: TextStyle(fontSize: Dimens.fontLarge, fontFamily: "Nunito", color: ColorResources.text),
            headlineSmall: TextStyle(
              fontSize: Dimens.headlineSmall,
              fontFamily: "Nunito",
              color: ColorResources.text,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontSize: Dimens.headlineMedium,
              fontFamily: "Nunito",
              color: ColorResources.text,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              fontSize: Dimens.headlineLarge,
              fontFamily: "Nunito",
              color: ColorResources.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: "Nunito",
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          iconTheme: const IconThemeData(color: ColorResources.icon),
          listTileTheme: const ListTileThemeData(
            dense: true,
            contentPadding: EdgeInsets.zero,
            iconColor: ColorResources.icon,
            textColor: ColorResources.text,
            titleTextStyle: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "Nunito", color: ColorResources.text),
            subtitleTextStyle: TextStyle(fontSize: Dimens.fontSmall, fontFamily: "Nunito", color: ColorResources.text),
            leadingAndTrailingTextStyle: TextStyle(
              fontSize: Dimens.fontDefault,
              fontFamily: "Nunito",
              color: ColorResources.text,
            ),
          ),
        ),
        supportedLocales: const [
          Locale("en", ""),
          Locale("id", ""),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        navigatorKey: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          var routes = {
            "/": (context) => const Launcher(),
            "/create_assignment": (context) =>  const CreateAssignmentPage(),
            "/create_device": (context) => const DevicePage(device: null),
            "/login": (context) => const LoginPage(),
            "/main_menu": (context) => MainMenuPage(user: settings.arguments as User),
            "/update_device": (context) =>  DevicePage(device: settings.arguments as Device),
          };
          WidgetBuilder? builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder!(context));
        },
      ),
    );
  }
}
