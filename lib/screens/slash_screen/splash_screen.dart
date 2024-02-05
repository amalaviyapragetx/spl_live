import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/controller/splash_screen_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/utils/constant.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final con = Get.put<SplashScreenController>(SplashScreenController());
  @override
  void initState() {
    super.initState();
    con.getLocation();
    con.checkLogin();
    con.getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.initDimension(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppColors.transparent,
        body: Image.asset(
          AppImage.splashScreen,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
