import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:signal/app/app/utills/app_utills.dart';

class RestConstant {
  static String baseUrl = 'https://fcm.googleapis.com/';
  static String endpoint = 'fcm/send';
}

class ResponseService {
  static bool connnect = false;
  static String? responceBody;
  static Map<String, dynamic>? bodyMap;

  static Future<String> postRestUrl(
      String sendMessage,String token) async {
    logs('token ------> $token');
    
    String serverKey ="AAAArjkbDns:APA91bFyHmRi6yP6YzdhjeSlm_6Jx89WYimP9scPdut4bJM2Hldx9tD4TW2BIBc4x-CjJRVrn6Rr6thqGpo0Im3wQ9VpllQS1n4myDoyJpIc_AlEqT-wDrtPaNiWig6fDyqHGmtAiipm";

    final url = "https://fcm.googleapis.com/${RestConstant.endpoint}";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final message = {
      'to': token,
      'notification': {
        'title': 'Chat App',
        'body': sendMessage,
      },
    };

    log('sendMessage --> $sendMessage');
    log('message --> $message');

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(message));
    try {
      log('Response status:${response.statusCode}');
      log('response body:${response.body}');
      responceBody = response.body;
      logs("response---->${response.body}");

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
