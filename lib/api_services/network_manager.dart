import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GetXNetworkManager extends GetxController {
  //this variable 0 = No Internet, 1 = connected to WIFI ,2 = connected to Mobile Data.
  int connectionType = 0;

  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream to keep listening to network change state
  late StreamSubscription _streamSubscription;

  RxBool isInternetReConnected = false.obs;
  bool isInternetDisconnected = false;

  @override
  void onInit() {
    getConnectionType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
    super.onInit();
  }

  Future<void> getConnectionType() async {
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return _updateState(connectivityResult!);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        if (isInternetDisconnected) {
          isInternetReConnected.value = true;
          isInternetReConnected.refresh();
        }
        isInternetDisconnected = false;

        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        if (isInternetDisconnected) {
          isInternetReConnected.value = true;
          isInternetReConnected.refresh();
        }
        isInternetDisconnected = false;

        break;
      case ConnectivityResult.none:
        connectionType = 0;
        isInternetDisconnected = true;
        isInternetReConnected.value = false;
        isInternetReConnected.refresh();

        break;
      default:
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
  }

  @override
  void onClose() {
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
  }
}
