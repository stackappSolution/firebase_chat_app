import 'package:get/get.dart';
import 'package:signal/controller/diappearing_controller.dart';
import 'package:signal/pages/settings/privacy/disappear/disappear_screen.dart';

class DisappearViewModel {
  DisappearScreen? disappearingMessagesScreen;
  DisappearingController? controller;

  List<String> selectedStatus = ['off', '4 weeks'];

  DisappearViewModel(this.disappearingMessagesScreen) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        controller = Get.find<DisappearingController>();
      },
    );
  }
}
