import 'package:signal/pages/setting_chats_page/setting_chat_screen.dart';

class SettingChatsViewModel{
  late SettingChatsViewModel? settingChatsViewModel;


  bool generateLink = false;
  bool useAddressBook = false;
  bool keepMuted = false;
  bool systemEmoji = false;
  bool keySends = false;

  SettingChatsViewModel(SettingChatScreen settingChatScreen);

}