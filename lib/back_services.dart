import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'api_services/api_service.dart';

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
// void onStart(ServiceInstance service) async {
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
//     appKilledStateApi();
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

// void appKilledStateApi() async {
//   ApiService().appKilledStateApi().then((value) async {
//     debugPrint("app kill App Version:- $value");
//     if (value['status']) {
//       print(value['data']);
//     }
//   });
// }
class BackgroundServices {
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
          // auto start service
          autoStart: true,
          onForeground: onStart,
          onBackground: onIsoBackground),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIsoBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  bool apiCalled = false;
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForground').listen((event) {
        service.setAsBackgroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      // appKilledStateApi();
      print(
          "===2sas=====sdsadsadsad=asd=sad=sad=sa=d=sa=d=s=d=sa=d=s=sad=sa=sa");
      service.stopSelf();
    });
    // Timer.periodic(Duration(seconds: 1), (timer) async {
    //   if (service is AndroidServiceInstance) {
    //     if (await service.isForegroundService()) {
    //       service.setAsBackgroundService();
    //     }
    //   }
    //   /////permorm some oprations on background which is not noticable to  the user everytime
    //   print("Back Ground Service is running ");
    //   service.invoke('update');
    // });
  }
  void appKilledStateApi() async {
    ApiService().appKilledStateApi().then((value) async {
      debugPrint("api call on app kill:- $value");
      if (value['status']) {
        print(value['data']);
      }
    });
  }
}
