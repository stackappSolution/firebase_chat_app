import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SettingsController extends GetxController {
  String selectedEmoji = '🤩';

  void selectEmoji(String emoji) {
    selectedEmoji = emoji;
    update();
  }
}
