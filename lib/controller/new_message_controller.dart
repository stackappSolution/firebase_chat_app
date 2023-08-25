import 'package:get/get.dart';

class NewMessageController extends GetxController{
  RxBool isSearch = false.obs;
  bool get searchValue => isSearch.value;
  RxString filteredValue=''.obs;

  void setSearch(bool value) {
    isSearch.value = value;
    update();
  }
  void setFilterText(String value) {
    filteredValue.value = value;
    update();
  }
}