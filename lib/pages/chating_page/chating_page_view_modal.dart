import 'package:flutter/material.dart';

class ChatingPageViewModal {
  List<PopupMenuEntry<String>> popupMenu = [
    const PopupMenuItem<String>(value: 'option1', child: Text('Option 1')),
    const PopupMenuItem<String>(value: 'option2', child: Text('Option 2')),
    const PopupMenuItem<String>(value: 'option3', child: Text('Option 3'))
  ];
  TextEditingController chatController = TextEditingController();

  List<String> message = [
    'Hyy',
    'Hello',
    'as',
    'ghjm ',
    'as',
    'adsasdwe',
    'aas',
    'sdf',
    'as',
    'dfsx'
  ];
  List<bool> isSender = [true, true, false, true, true, false, false, false, true, false];
  List<DateTime> messageTimestamps = [];

  ChatingPageViewModal() {
    messageTimestamps.add(DateTime(2023, 8, 16, 10, 30));
    messageTimestamps.add(DateTime(2023, 8, 16, 11, 45));
    messageTimestamps.add(DateTime(2023, 8, 16, 12, 30));
    messageTimestamps.add(DateTime(2023, 8, 16, 1, 45));
    messageTimestamps.add(DateTime(2023, 8, 16, 2, 30));
    messageTimestamps.add(DateTime(2023, 8, 16, 3, 45));
    messageTimestamps.add(DateTime(2023, 8, 16, 4, 30));
    messageTimestamps.add(DateTime(2023, 8, 16, 5, 45));
    messageTimestamps.add(DateTime(2023, 8, 16, 6, 30));
    messageTimestamps.add(DateTime(2023, 8, 16, 7, 45));
  }
}
