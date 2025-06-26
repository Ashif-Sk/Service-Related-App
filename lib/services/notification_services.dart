import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  static void show(RemoteNotification notification) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("chat_channel", "Chat Notifications",
            priority: Priority.high,
            importance: Importance.max,
            playSound: true,
            enableVibration: true);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _plugin.show(notification.hashCode, notification.title,
        notification.body, notificationDetails);
  }

  static void notificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        show(message.notification!);
      }
    });
  }

  static Future<String?> saveTokenToFirestore (String userId) async {
    final fcmToken = FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "fcmToken" : fcmToken
    });
    return fcmToken;
    }


    Future<void> sendPushNotification({required String token,required String title,required String body}) async{
      const String serverKey = '';
      try{
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : 'key=$serverKey'
          },
          body: jsonEncode({
            "to" : token,
            "notification" : {
              "title" : title,
              "body" : body,
              "sound" : "default"
            },
            "priority" : "high" ,
          })

        );
      } catch(e){
        print("error in sending message${e.toString()}");
      }
    }
}
