import 'package:intl/intl.dart';

class DateFormation {
  static String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    int minuteDifference = now.difference(dateTime).inMinutes;
    if (minuteDifference < 1) {
      return 'Now';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day + 1) {
      return 'Tomorrow';
    } else {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      return dateFormat.format(dateTime);
    }
  }


  getChatTimeFormate(int time){
    int millisecondsSinceEpoch = time; // Example timestamp

    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch);
    String formattedTime =
    DateFormat('HH:mm').format(dateTime);


    return formattedTime;
  }


}
