import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/service/notification_service.dart';

class RestConstant {
  static String Baseurl = 'https://fcm.googleapis.com/';
  static String endpoint = 'fcm/send';
}

class ResponseService {
  // static  String ?msg ;
  static bool connnect = false;
  static String? responceBody;
  static Map<String, dynamic>? Bodymap;

  static Future<String> PostRestUrl(
      String endpoint, Map<String, dynamic> BodyMap, msg,String messageType) async {
    String serverKey =
        "AAAAtzZoiJ0:APA91bEJUKsYrPg7vQ2D1xQgA4m4YwZKOc2uXJHJ__HziGDQdQE7gvISuAmBRmD3OF9sCFhPQsrZ0tTU-Me1_OEZDturmPreCm3Oqzw0jFM6cMunbJR0lXwF5pTgDVaRIS54OdcahoZS";
     String registrationToken =
        await FirebaseMessaging.instance.getToken() ?? '';
     logs('REGISTRATION TOKEN -->$registrationToken');

    const url = "https://fcm.googleapis.com/fcm/send";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final message = {
      'to': registrationToken,
      'notification': {
        'title': 'Chat App',
        'body': msg,
      },
      'data':{
        'messageType':messageType,
      }
    };

    log('message --> $message');

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(message));
    Map<String, dynamic> bodyMap = {"useFor": "message"};
    logs('bodymaoppp-->$bodyMap');
    try {
      log('Response status:${response.statusCode}');
      log('response body:${response.body}');
      responceBody = response.body;
      print("response---->${response.body}");

      switch (response.body) {
        case 200:
      }
      return response.body;
    } on Exception catch (e) {
      log("throwing new error$e");
      throw Exception("Error on server");
    }
  }
}
