import 'package:get/get.dart';
import 'package:signal/service/database_service.dart';

class ChatProfileController extends GetxController{

  RxList<String> blockedUsers = <String>[].obs;


  blockUser(String usersNumber){
    blockedUsers.add(usersNumber);
    DatabaseService()
        .blockUser(blockedUsers);
    update();
  }


  unBlockUser(String userNumber){
    blockedUsers.remove(userNumber);
    DatabaseService().unblockUser(userNumber);
    update();
  }




}