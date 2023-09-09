import 'package:signal/pages/settings/privacy/blocked/blocked_users_screen.dart';

class BlockedUsersViewModel {
  BlockedUsersScreen? blockedUsersScreen;

  List<String> blockedUsersList = [];

  BlockedUsersViewModel(this.blockedUsersScreen);
}
