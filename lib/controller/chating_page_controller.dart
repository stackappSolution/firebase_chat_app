
import 'package:get/get.dart';
import 'package:signal/pages/chating_page/chating_page.dart';


import '../app/app/utills/app_utills.dart';
import '../pages/chating_page/chating_page_view_modal.dart';

class ChatingPageController extends GetxController {
  ChatingPage? chatingPage;
  ChatingPageViewModal chatingPageViewModal = ChatingPageViewModal();

  @override
  void onInit() {
    // TODO: implement onInit
    logs("call onInit");
    super.onInit();
    ChatingPage.fontSize = '${chatingPageViewModal.fontSizeInitState()}';
  }


}
