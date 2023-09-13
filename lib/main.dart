import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/Custom%20Controllers/doubletap_exitcontroller.dart';
import 'Push Notification/notificationservices.dart';
import 'helper_files/constant_variables.dart';
import 'localization/app_localization.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_name.dart';
import 'screens/Local Storage.dart';
import 'screens/initial_bindings.dart';
import 'self_closing_page.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessegingBackgroundHendler(RemoteMessage msg) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessegingBackgroundHendler);
  await GetStorage.init();
  await Permission.location.request();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Location location = Location();
  var conrroller = Get.put(InactivityController());
  var exitondoubleTap = Get.put(DoubleTapExitController());
  @override
  void initState() {
    NotificationServices().requestNotificationPermission();
    //  notificationServices.isTokenRefresh();
    HttpOverrides.global = MyHttpOverrides();
    NotificationServices().firebaseInit(context);
    NotificationServices().setuoIntrectMessege(context);
    NotificationServices().getDeviceToken().then((value) {
      print("Device Token : $value");
      LocalStorage.write(ConstantsVariables.fcmToken, value);
    });
    // statusCheck();
    getLocation();
    super.initState();
  }

  // statusCheck() async {
  //   final status = await Permission.location.status;
  //   if (status.isDenied) {
  //     SystemNavigator.pop();
  //   } else {
  //     await Permission.location.request();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return Listener(
          onPointerSignal: conrroller.userLogIn,
          onPointerDown: conrroller.userLogIn,
          onPointerMove: conrroller.userLogIn,
          onPointerUp: conrroller.userLogIn,
          child: GetMaterialApp(
            title: 'SPL app',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            defaultTransition: Transition.fadeIn,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            transitionDuration: const Duration(milliseconds: 500),
            translations: AppLocalization(),
            locale: getLocale(),
            initialBinding: InitialBindings(),
            initialRoute: AppRoutName.splashScreen,
            getPages: AppRoutes.pages,
          ),
        );
      },
    );
  }

  Future<void> getLocation() async {
    final locationData = await location.getLocation();
    print(
        'Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
  }

  Locale getLocale() {
    var storedLocale = LocalStorage.read(ConstantsVariables.languageName);
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
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
