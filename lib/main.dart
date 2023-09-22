import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
  final appStateListener = AppStateListener();
  WidgetsBinding.instance.addObserver(appStateListener);
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
  // final Location location = Location();
 

  var conrroller = Get.put(InactivityController());
  var exitondoubleTap = Get.put(DoubleTapExitController());
  // bool apiCalled = false;
  @override
  void initState() {
    // BackgroundServices().initializeService();
    NotificationServices().requestNotificationPermission();
    //  notificationServices.isTokenRefresh();
    HttpOverrides.global = MyHttpOverrides();
    NotificationServices().firebaseInit(context);
    NotificationServices().setuoIntrectMessege(context);
    NotificationServices().getDeviceToken().then((value) {
      print("Device Token : $value");
      LocalStorage.write(ConstantsVariables.fcmToken, value);
    });

    // if (!apiCalled) {
    //   // Call your API here.
    //   // Make sure to check the return value of the API call, and handle any errors accordingly.

    //   apiCalled = true;
    // }

    // SystemChannels.lifecycle.setMessageHandler((message) async {
    //   if (message == 'appWillTerminate') {
    //     if (apiCalled) {
    //       print("call hoja bhai ap kya paisa lega");
    //       // Call your API again here.
    //       // Make sure to check the return value of the API call, and handle any errors accordingly.
    //     }
    //   }
    // });
    // _getLocation();
    super.initState();
  }

  // Future<void> initializeService() async {
  //   final service = FlutterBackgroundService();
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will executed when app is in foreground or background in separated isolate
  //       onStart: onStart,
  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //         // auto start service
  //         autoStart: true,
  //         onForeground: onStart,
  //         onBackground: onIsoBackground),
  //   );
  // }

  // @pragma('vm:entry-point')
  // Future<bool> onIsoBackground(ServiceInstance service) async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   DartPluginRegistrant.ensureInitialized();
  //   return true;
  // }

  // @pragma('vm:entry-point')
  // static void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();

  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //     service.on('setAsBackground').listen((event) {
  //       print(
  //           "================================================================");
  //       service.setAsBackgroundService();
  //     });
  //   }

  //   service.on('stopService').listen((event) {
  //     print("-=======================");
  //     service.stopSelf();
  //   });

  //   Timer.periodic(Duration(seconds: 1), (timer) async {
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         service.setAsBackgroundService();
  //       }
  //     }
  //     /////permorm some oprations on background which is not noticable to  the user everytime
  //     print("Back Ground Service is running ");
  //     service.invoke('update');
  //   });
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

  // Future<void> getLocation() async {
  //   final locationData = await location.getLocation();
  //   print(
  //       'Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
  // }

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

class AppStateListener extends WidgetsBindingObserver {
  var conrroller = Get.put(InactivityController());
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // App is going to be terminated
      // Call the API
      print("chala ja");
      // conrroller.appKilledStateApi();
    } else {
      print("================================================================");
    }
  }
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // App is in the foreground
  //       print("App is in the foreground");
  //       break;
  //     case AppLifecycleState.inactive:
  //       // App is in an inactive state, possibly transitioning between foreground and background

  //       print("App is in an inactive state");
  //       break;
  //     case AppLifecycleState.paused:

  //       // App is in the background
  //       print("App is in the background");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("App is terminated");
  //       break;
  //   }
  // }
}
        // Timer(Duration(minutes: 1), () {
        //   // conrroller.appKilledStateApi();
        //   // Timer(Duration(seconds: 2), () {
        //   //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        //   // });
        // });