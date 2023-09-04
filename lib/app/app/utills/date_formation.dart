import 'package:intl/intl.dart';

class DateFormation {
  static String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 5) {
      return '1 minute ago';
    } else if (difference.inMinutes < 10) {
      return '5 minutes ago';
    } else if (difference.inMinutes < 15) {
      return '10 minutes ago';
    } else if (difference.inMinutes < 20) {
      return '15 minutes ago';
    } else if (difference.inMinutes < 25) {
      return '20 minutes ago';
    } else if (difference.inMinutes < 30) {
      return '25 minutes ago';
    } else if (difference.inMinutes < 35) {
      return '30 minutes ago';
    } else if (difference.inMinutes < 40) {
      return '35 minutes ago';
    } else if (difference.inMinutes < 45) {
      return '40 minutes ago';
    } else if (difference.inMinutes < 50) {
      return '45 minutes ago';
    } else if (difference.inMinutes < 55) {
      return '50 minutes ago';
    } else if (difference.inHours < 1) {
      return '55 minutes ago';
    } else if (difference.inHours < 2) {
      return '1 hour ago';
    } else if (difference.inHours < 3) {
      return '2 hours ago';
    } else if (difference.inHours < 4) {
      return '3 hours ago';
    } else if (difference.inHours < 5) {
      return '4 hours ago';
    } else if (difference.inHours < 6) {
      return '5 hours ago';
    } else if (difference.inHours < 7) {
      return '6 hours ago';
    } else if (difference.inHours < 8) {
      return '7 hours ago';
    } else if (difference.inHours < 9) {
      return '8 hours ago';
    } else if (difference.inHours < 10) {
      return '9 hours ago';
    } else if (difference.inHours < 11) {
      return '10 hours ago';
    } else if (difference.inHours < 12) {
      return '11 hours ago';
    } else if (difference.inHours < 13) {
      return '12 hours ago';
    } else if (difference.inHours < 14) {
      return '13 hours ago';
    } else if (difference.inHours < 15) {
      return '14 hours ago';
    } else if (difference.inHours < 16) {
      return '15 hours ago';
    } else if (difference.inHours < 17) {
      return '16 hours ago';
    } else if (difference.inHours < 18) {
      return '17 hours ago';
    } else if (difference.inHours < 19) {
      return '18 hours ago';
    } else if (difference.inHours < 20) {
      return '19 hours ago';
    } else if (difference.inHours < 21) {
      return '20 hours ago';
    } else if (difference.inHours < 22) {
      return '21 hours ago';
    } else if (difference.inHours < 23) {
      return '22 hours ago';
    } else if (difference.inHours < 24) {
      return '23 hours ago';
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

  getChatTimeFormate(int time) {
    int millisecondsSinceEpoch = time; // Example timestamp

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }
}
