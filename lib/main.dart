import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:k3_sipp_mobile/bloc/examination/examination_cubit.dart';
import 'package:k3_sipp_mobile/bloc/examination/device_calibration_cubit.dart';
import 'package:k3_sipp_mobile/bloc/company/companies_bloc.dart';
import 'package:k3_sipp_mobile/bloc/device/devices_bloc.dart';
import 'package:k3_sipp_mobile/bloc/menu/menu_cubit.dart';
import 'package:k3_sipp_mobile/bloc/user/users_bloc.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/ui/assignment/add_update_examination_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/create_assignment_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/ui/auth/login_page.dart';
import 'package:k3_sipp_mobile/ui/company/companies_page.dart';
import 'package:k3_sipp_mobile/ui/device/device_page.dart';
import 'package:k3_sipp_mobile/ui/device/devices_page.dart';
import 'package:k3_sipp_mobile/ui/launcher.dart';
import 'package:k3_sipp_mobile/ui/main/assignment_page.dart';
import 'package:k3_sipp_mobile/ui/main/main_menu_page.dart';
import 'package:k3_sipp_mobile/ui/user/user_page.dart';
import 'package:k3_sipp_mobile/ui/user/users_page.dart';

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
        BlocProvider<ExaminationsCubit>(create: (context) => ExaminationsCubit()),
        BlocProvider<DeviceCalibrationCubit>(create: (context) => DeviceCalibrationCubit()),
        BlocProvider<UsersBloc>(create: (context) => UsersBloc()),
        BlocProvider<DevicesBloc>(create: (context) => DevicesBloc()),
        BlocProvider<CompaniesBloc>(create: (context) => CompaniesBloc()),
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
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(color: ColorResources.primaryDark),
            actionsIconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontSize: Dimens.fontToolbar,
              fontFamily: "Nunito",
              color: ColorResources.highlight,
            ),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: Dimens.fontXSmall, fontFamily: "Nunito", color: ColorResources.text),
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
            "/login": (context) => const LoginPage(),
            "/main_menu": (context) => MainMenuPage(user: settings.arguments as User),

            //Assignment
            "/assignment_page": (context) => const AssignmentPage(),
            "/create_assignment": (context) => const CreateAssignmentPage(),

            //Examination
            "/add_examination_page": (context) => const AddOrUpdateExaminationPage(),
            "/update_examination_page": (context) =>
                AddOrUpdateExaminationPage(examination: settings.arguments == null ? null : settings.arguments as Examination),
            "/input_form": (context) => const InputFormPage(),

            //Device
            "/devices": (context) => const DevicesPage(pageMode: DevicesPageMode.deviceList),
            "/select_device": (context) => const DevicesPage(pageMode: DevicesPageMode.selectDevice),
            "/create_device": (context) => const DevicePage(),
            "/update_device": (context) => DevicePage(device: settings.arguments as Device),

            //Company
            "/companies": (context) => const CompaniesPage(pageMode: CompaniesPageMode.companyList),
            "/select_company": (context) => const CompaniesPage(pageMode: CompaniesPageMode.selectCompany),

            //User
            "/select_user": (context) => UsersPage(
                pageMode: UsersPageMode.selectUser, filter: settings.arguments == null ? null : settings.arguments as UserFilter),
            "/users": (context) => UsersPage(
                pageMode: UsersPageMode.userList, filter: settings.arguments == null ? null : settings.arguments as UserFilter),
            "/create_user": (context) => const UserPage(),
            "/update_user": (context) => UserPage(user: settings.arguments as User),
          };
          WidgetBuilder? builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder!(context));
        },
      ),
    );
  }
}
