import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:spllive/api/request/auth_api.dart';
import 'package:spllive/api/request/home_api.dart';
import 'package:spllive/api/services/auth_service.dart';
import 'package:spllive/api/services/home_service.dart';
import 'package:spllive/utils/constant.dart';

import 'dio_client.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  final accessToken = await GetStorage().read(ConstantsVariables.authToken);
  Logger().i("\x1B[33mFCM TOKEN =>\x1B[32m $fcmToken\n\x1B[33mACCESS TOKEN =>\x1B[32m $accessToken");
  await GetStorage().write(ConstantsVariables.fcmToken, fcmToken);
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(AuthApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(AuthService(getIt.get<AuthApi>()));
  getIt.registerSingleton(HomeApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(HomeService(getIt.get<HomeApi>()));
}
