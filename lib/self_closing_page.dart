import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _isActive = true;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    //  startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  void startTimer() {
    _isActive = false;
    _timer = Timer(const Duration(minutes: 3), () {
      if (!_isActive) {
        ///  Get.close(1); // Close the app entirely.
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.inactive) {
    //   resetTimer();
    // } else {
    //   startTimer();
    // }
  }
}



// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class AppLifecycleController extends GetxController
//     with WidgetsBindingObserver {
//   ValueNotifier<bool> _appActiveNotifier = ValueNotifier<bool>(true);
//   Timer? _timer;
//   bool _isActive = true;

//   @override
//   void onInit() {
//     WidgetsBinding.instance.addObserver(this);
//     _appActiveNotifier.addListener(_handleAppActivityChange);

//     super.onInit();
//   }

//   void _handleAppActivityChange() {
//     if (_appActiveNotifier.value) {
//       _resetTimer();
//     }
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     _appActiveNotifier.removeListener(_handleAppActivityChange);
//     WidgetsBinding.instance.removeObserver(this);

//     super.onClose();
//   }

//   void _resetTimer() {
//     _timer?.cancel();
//     _timer = Timer(const Duration(minutes: 3), () {
//       Get.close(1); // Close the app entirely.
//       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.inactive) {
//       _appActiveNotifier.value = false;
//     } else if (state == AppLifecycleState.resumed) {
//       _appActiveNotifier.value = true;
//     }
//   }
// }
