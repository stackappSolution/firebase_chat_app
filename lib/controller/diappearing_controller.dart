import 'package:get/get.dart';

class DisappearingController extends GetxController{

  RxString selectedValue = 'off'.obs;

  void updateSelectedValue(String value) {
    selectedValue.value = value;
    update();
  }

}