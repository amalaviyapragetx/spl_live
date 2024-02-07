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

@pragma('vm:entry-point')
Future<void> _firebaseMessegingBackgroundHendler(RemoteMessage msg) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessegingBackgroundHendler);
  await GetStorage.init();
  // await Permission.location.request();
  final appStateListener = AppStateListener();
  WidgetsBinding.instance.addObserver(appStateListener);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    // showPermissionDialog(checkUserGrantPermission());
    // BackgroundServices().initializeService();
    NotificationServices().requestNotificationPermission();
    //  notificationServices.isTokenRefresh();
    HttpOverrides.global = MyHttpOverrides();
    NotificationServices().firebaseInit(context);
    NotificationServices().setuoIntrectMessege(context);
    NotificationServices().getDeviceToken().then((value) {
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
    //
    //       // Call your API again here.
    //       // Make sure to check the return value of the API call, and handle any errors accordingly.
    //     }
    //   }
    // });
    // _getLocation();
    // checkUserGrantPermission();

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

  //       service.setAsBackgroundService();
  //     });
  //   }

  //   service.on('stopService').listen((event) {

  //     service.stopSelf();
  //   });

  //   Timer.periodic(Duration(seconds: 1), (timer) async {
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         service.setAsBackgroundService();
  //       }
  //     }
  //     /////permorm some oprations on background which is not noticable to  the user everytime

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
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// checkUserGrantPermission() async {
//   if (await Permission.location.isDenied) {
//     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//     Permission.location.request();
//     // AppSettings.openAppSettings();
//   }
// }

// void showPermissionDialog() {
//   Get.defaultDialog(
//     title: 'Permission Required',
//     content: Text('Please grant notification permission to proceed.'),
//     actions: <Widget>[
//       ElevatedButton(
//         child: Text('OK'),
//         onPressed: () async {
//           Get.back();
//           await Permission.location.request();
//           // AppSettings.openAppSettings();
//           // Callback to handle permission request
//         },
//       ),
//     ],
//   );
// }

class AppStateListener extends WidgetsBindingObserver {
  var conrroller = Get.put(InactivityController());
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        bool alreadyLoggedIn = await conrroller.getStoredUserData();
        var mPinTimeOut = await LocalStorage.read(ConstantsVariables.mPinTimeOut) ?? true;
        if (alreadyLoggedIn && !mPinTimeOut) {
          await LocalStorage.write(ConstantsVariables.timeOut, true);
        } else {
          await LocalStorage.write(ConstantsVariables.timeOut, false);
        }
        //    splashConrroller.requestLocationPermission();
        break;
      case AppLifecycleState.inactive:
        await LocalStorage.write(ConstantsVariables.timeOut, false);

        ///   splashConrroller.requestLocationPermission();
        break;
      case AppLifecycleState.paused:
        await LocalStorage.write(ConstantsVariables.timeOut, false);
        // App is in the background
        //  splashConrroller.requestLocationPermission();
        break;
      case AppLifecycleState.detached:
        await LocalStorage.write(ConstantsVariables.timeOut, false);
        break;
    }
  }
}

// class PermissionScreen extends StatelessWidget {
//   Future<void> _requestLocationPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       // Permission granted, proceed with your flow.
//
//     } else if (status.isDenied) {
//       // Permission denied.
//       Get.defaultDialog(
//         title: 'Permission Denied',
//         middleText: 'Please grant location permission to use this feature.',
//         confirm: ElevatedButton(
//           onPressed: () {
//             Get.back();
//             openAppSettings(); // Open app settings if permission is denied.
//           },
//           child: Text('Open Settings'),
//         ),
//       );
//     } else if (status.isPermanentlyDenied) {
//       // Permission permanently denied.
//       Get.defaultDialog(
//         title: 'Permission Permanently Denied',
//         middleText: 'Please enable location permission in your app settings.',
//         confirm: ElevatedButton(
//           onPressed: () {
//             Get.back();
//             openAppSettings(); // Open app settings if permission is permanently denied.
//           },
//           child: Text('Open Settings'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
