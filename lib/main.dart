import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spllive/helper_files/app_colors.dart';

import 'Push Notification/notificationservices.dart';
import 'helper_files/constant_variables.dart';
import 'localization/app_localization.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_name.dart';
import 'screens/initial_bindings.dart';
import 'self_closing_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessegingBackgroundHendler(RemoteMessage msg) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessegingBackgroundHendler);
  await GetStorage.init();
  final appStateListener = AppStateListener();
  WidgetsBinding.instance.addObserver(appStateListener);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.appBlueDarkColor,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final con = Get.put<InactivityController>(InactivityController());
  bool _jailbroken = false;

  @override
  void initState() {
    super.initState();
    NotificationServices().requestNotificationPermission();
    HttpOverrides.global = MyHttpOverrides();
    NotificationServices().firebaseInit(context);
    NotificationServices().setuoIntrectMessege(context);
    NotificationServices().getDeviceToken().then((value) => GetStorage().write(ConstantsVariables.fcmToken, value));
    print("ConstantsVariables.fcmTokenConstantsVariables.fcmToken ${GetStorage().read(ConstantsVariables.fcmToken)}");
    //   initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   bool jailbroken;
  //   try {
  //     jailbroken = await FlutterJailbreakDetection.jailbroken;
  //   } on PlatformException {
  //     jailbroken = true;
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _jailbroken = jailbroken;
  //     if (_jailbroken) {
  //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: AppColors.appBlueDarkColor,
    //   statusBarBrightness: Brightness.dark,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (e) => con.resetInactivityTimer(),
          child: Listener(
            onPointerSignal: con.userLogIn,
            onPointerDown: con.userLogIn,
            onPointerMove: con.userLogIn,
            onPointerUp: con.userLogIn,
            onPointerHover: con.userLogIn,
            onPointerPanZoomStart: con.userLogIn,
            onPointerPanZoomUpdate: con.userLogIn,
            child: GetMaterialApp(
              title: 'SPL app',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: AppColors.white,
                dialogTheme: DialogTheme(surfaceTintColor: AppColors.white),
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: AppColors.white),
                  scrolledUnderElevation: 0,
                ),
              ),
              defaultTransition: Transition.fadeIn,
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              // transitionDuration: const Duration(milliseconds: 500),
              translations: AppLocalization(),
              locale: getLocale(),
              initialBinding: InitialBindings(),
              initialRoute: AppRoutName.splashScreen,
              getPages: AppRoutes.pages,
            ),
          ),
        );
      },
    );
  }

  Locale getLocale() {
    final storedLocale = GetStorage().read(ConstantsVariables.languageName);
    var locale = const Locale('en', 'US');
    switch (storedLocale) {
      case ConstantsVariables.localeEnglish:
        locale = const Locale('en', 'US');
        break;
      case ConstantsVariables.localeHindi:
        locale = const Locale('hi', 'IN');
        break;
      default:
        locale = const Locale('en', 'US');
    }
    return locale;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class AppStateListener extends WidgetsBindingObserver {
  final con = Get.put<InactivityController>(InactivityController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        bool alreadyLoggedIn = con.getStoredUserData();
        var mPinTimeOut = GetStorage().read(ConstantsVariables.mPinTimeOut) ?? true;
        if (alreadyLoggedIn && !mPinTimeOut) {
          GetStorage().write(ConstantsVariables.timeOut, true);
        } else {
          GetStorage().write(ConstantsVariables.timeOut, false);
        }
        break;
      case AppLifecycleState.inactive:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
      case AppLifecycleState.paused:
        GetStorage().write(ConstantsVariables.timeOut, false);

        break;
      case AppLifecycleState.detached:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
      case AppLifecycleState.hidden:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
    }
  }
}
