// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// class PushNotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Request permission for notifications
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       announcement: true,
//       criticalAlert: true,
//       carPlay: true,
//     );

//     Future<void> initialize() async {
//       // Request permission for notifications
//       NotificationSettings settings =
//           await _firebaseMessaging.requestPermission(
//         announcement: true,
//         criticalAlert: true,
//         carPlay: true,
//       );
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('Notification permission granted');
//       } else {
//         print('Notification permission denied');
//       }
//       // Get the token for this device
//       String? token = await _firebaseMessaging.getToken();
//       print('Firebase Messaging Token: $token');
//       // Handle incoming messages
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print('Received a message: ${message.notification?.body}');
//       });
//       // Handle when the app is in the background but opened by tapping on a notification
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print('Message opened app: ${message.notification?.body}');
//       }); 
//     }
//   }
// }
