import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spllive/api/service_locator.dart';
import 'package:spllive/routes/app_routes.dart';
import 'package:spllive/utils/constant.dart';

import 'firebase_options.dart';
import 'localization/app_localization.dart';
import 'screens/Local Storage.dart';
import 'screens/initial_bindings.dart';
import 'self_closing_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showNotification(message);
}

showNotification(RemoteMessage message) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      channelKey: "notification",
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
      fullScreenIntent: true,
      autoDismissible: false,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppStateListener());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();
  await Permission.location.request();
  await setup();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "notification",
        channelName: "Call Channel ",
        channelDescription: "Channel of calling",
        defaultColor: AppColor.appbarColor,
        ledColor: AppColor.black,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
      )
    ],
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return Listener(
          onPointerSignal: con.userLogIn,
          onPointerDown: con.userLogIn,
          onPointerMove: con.userLogIn,
          onPointerUp: con.userLogIn,
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
            initialRoute: AppRouteNames.splashScreen,
            getPages: AppRoutes.pages,
          ),
        );
      },
    );
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
      case AppLifecycleState.hidden:
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
//       print('Location permission granted');
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
