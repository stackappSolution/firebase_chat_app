import 'package:intl/intl.dart';

class DateFormation {
  static String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 5) {
      return '1m';
    } else if (difference.inMinutes < 10) {
      return '5m';
    } else if (difference.inMinutes < 15) {
      return '10m';
    } else if (difference.inMinutes < 20) {
      return '15m';
    } else if (difference.inMinutes < 25) {
      return '20m';
    } else if (difference.inMinutes < 30) {
      return '25m';
    } else if (difference.inMinutes < 35) {
      return '30m';
    } else if (difference.inMinutes < 40) {
      return '35m';
    } else if (difference.inMinutes < 45) {
      return '40m';
    } else if (difference.inMinutes < 50) {
      return '45m';
    } else if (difference.inMinutes < 55) {
      return '50m';
    } else if (difference.inHours < 1) {
      return '55m';
    } else if (difference.inHours < 2) {
      return '1h';
    } else if (difference.inHours < 3) {
      return '2h';
    } else if (difference.inHours < 4) {
      return '3h';
    } else if (difference.inHours < 5) {
      return '4h';
    } else if (difference.inHours < 6) {
      return '5h';
    } else if (difference.inHours < 7) {
      return '6h';
    } else if (difference.inHours < 8) {
      return '7h';
    } else if (difference.inHours < 9) {
      return '8h';
    } else if (difference.inHours < 10) {
      return '9h';
    } else if (difference.inHours < 11) {
      return '10h';
    } else if (difference.inHours < 12) {
      return '11h';
    } else if (difference.inHours < 13) {
      return '12h';
    } else if (difference.inHours < 14) {
      return '13h';
    } else if (difference.inHours < 15) {
      return '14h';
    } else if (difference.inHours < 16) {
      return '15h';
    } else if (difference.inHours < 17) {
      return '16h';
    } else if (difference.inHours < 18) {
      return '17h';
    } else if (difference.inHours < 19) {
      return '18h';
    } else if (difference.inHours < 20) {
      return '19h';
    } else if (difference.inHours < 21) {
      return '20h';
    } else if (difference.inHours < 22) {
      return '21h';
    } else if (difference.inHours < 23) {
      return '22h';
    } else if (difference.inHours < 24) {
      return '23h';
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

  getDatetime(int time){
    int millisecondsSinceEpoch = time; // Example timestamp

    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    return dateTime;
  }

  String headerTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM d, y').format(dateTime);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

}
