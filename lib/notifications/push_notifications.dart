

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/main.dart';

class PushNotification {
  final FirebaseMessaging firebaseMessaging  = FirebaseMessaging.instance;

  Future initialize(context)async{
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage =message.data['route'];
      Navigator.pushNamed(context, routeFromMessage);
      print('  ====== route $routeFromMessage');
    });


  }

  Future<String> getToken()async{
    String token = await firebaseMessaging.getToken();


  }

}