import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:signal/pages/account/change_phone/change_phone_screen.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';
import 'package:signal/pages/chating_page/attachment/attachment_screen.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/chating_page/image_view/image_view.dart';
import 'package:signal/pages/chating_page/video_view/video_player_view.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_screen.dart';
import 'package:signal/pages/chats/chat_theme/chat_color.dart';
import 'package:signal/pages/chats/chat_theme/chat_color_wallapaper_screen.dart';
import 'package:signal/pages/chats/chat_theme/chat_wallpaper.dart';
import 'package:signal/pages/chats/chat_theme/wallpaper_preview_screen.dart';
import 'package:signal/pages/donate_amount_page/donate_page.dart';
import 'package:signal/pages/donate_to_chat_app/donate_to_chat_page.dart';
import 'package:signal/pages/edit_profile/add_photo_screen.dart';
import 'package:signal/pages/groups/group_name/group_name_screen.dart';
import 'package:signal/pages/groups/view/new_group_screen.dart';
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/pages/invite/invite_member_screen.dart';
import 'package:signal/pages/new_message_page/new_message_page.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/pages/settings/contact_us/contact_us_screen.dart';
import 'package:signal/pages/settings/help/help_settings_screen.dart';
import 'package:signal/pages/settings/licenses/licenses_screen.dart';
import 'package:signal/pages/settings/privacy/blocked/blocked_users_screen.dart';
import 'package:signal/pages/settings/privacy/disappear/disappear_screen.dart';
import 'package:signal/pages/settings/privacy/privacy_screen.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/pages/sign_in_page/sign_in_page.dart';
import 'package:signal/routes/routes_constant.dart';

import '../pages/account/account/account_screen.dart';
import '../pages/account/addvance_pin_setting/advance_pin_setting.dart';
import '../pages/account/pin_setting/pin_setting_screen.dart';
import '../pages/chats/chat_screen.dart';
import '../pages/splash/splash_screen.dart';

class RouteHelper {
  static String getSignInPage() => RouteConstant.signInPage;

  static String getVerifyOtpPage() => RouteConstant.verifyOtpScreen;

  static String getSettingsScreen() => RouteConstant.settingsScreen;

  static String getHomeScreen() => RouteConstant.homeScreen;

  static String getSettingScreen() => RouteConstant.settingScreen;

  static String getAppearanceScreen() => RouteConstant.appearanceScreen;

  static String getProfileScreen() => RouteConstant.profileScreen;

  static String getIntroScreen() => RouteConstant.introScreen;

  static String getSplashScreen() => RouteConstant.splashScreen;

  static String getVideoPlayerScreen() => RouteConstant.videoPlayerView;

  static String getChatColorWallpaperScreen() =>
      RouteConstant.chatColorWallpaperScreen;

  static String getWallpaperPreviewScreen() =>
      RouteConstant.wallpaperPreviewScreen;

  static String getChattingScreen() => RouteConstant.chatingScreen;

  static String getChatColorScreen() => RouteConstant.chatColorScreen;

  static String getChatWallpaperScreen() => RouteConstant.chatWallpaperScreen;

  static String getAddPhotoScreen() => RouteConstant.addPhotoScreen;

  static String getAccountScreen() => RouteConstant.accountScreen;

  static String getChangePinScreen() => RouteConstant.changePinScreen;

  static String getAdvancePinSettingScreen() => RouteConstant.advancePinSetting;

  static String getChangePhoneScreen() => RouteConstant.changePhoneScreen;

  static String getHelpSettingsScreen() => RouteConstant.helpSettingsScreen;

  static String getContactUsScreen() => RouteConstant.contactUsScreen;

  static String getLicensesScreen() => RouteConstant.licensesScreen;

  static String getChatProfileScreen() => RouteConstant.chatProfileScreen;

  static String getPrivacyScreen() => RouteConstant.privacyScreen;

  static String getImageViewScreen() => RouteConstant.imageViewScreen;

  static String getBlockedUsersScreen() => RouteConstant.blockedUsersScreen;

  static String getDisappearingScreen() => RouteConstant.disappearingScreen;

  static String getNewMessageScreen() => RouteConstant.newMessageScreen;

  static String getChatPhoneScreen() => RouteConstant.changePhoneScreen;

  static String getInviteMemberScreen() => RouteConstant.inviteMemberScreen;

  static String getNewGroupScreen() => RouteConstant.newGroupsScreen;

  static String getGroupNameScreen() => RouteConstant.groupNameScreen;

  static String getAttachmentScreen() => RouteConstant.attachmentScreen;

  static String getChatContactScreen() => RouteConstant.chatScreen;

  static String getFileView() => RouteConstant.fileView;

  static String getDonateToChatScreen() => RouteConstant.donateToChatScreen;

  static String getDonateScreen() => RouteConstant.donateScreen;

  static List<GetPage> routes = [
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(
      name: RouteConstant.signInPage,
      page: () => SignInPage(),
    ),
    GetPage(name: RouteConstant.settingsScreen, page: () => SettingScreen()),
    GetPage(name: RouteConstant.imageViewScreen, page: () => ImageView()),
    GetPage(name: RouteConstant.newMessageScreen, page: () => NewMessagePage()),
    GetPage(name: RouteConstant.homeScreen, page: () => HomeScreen()),
    GetPage(name: RouteConstant.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RouteConstant.splashScreen, page: () => SplashScreen()),
    GetPage(name: RouteConstant.initial, page: () => IntroPage()),
    GetPage(name: RouteConstant.chatingScreen, page: () => ChatingPage()),
    GetPage(name: RouteConstant.profileScreen, page: () => ProfileScreen()),
    GetPage(
        name: RouteConstant.inviteMemberScreen,
        page: () => InviteMemberScreen()),
    GetPage(name: RouteConstant.newGroupsScreen, page: () => NewGroupScreen()),
    GetPage(name: RouteConstant.groupNameScreen, page: () => GroupNameScreen()),
    GetPage(name: RouteConstant.videoPlayerView, page: () => VideoPlayerView()),
    GetPage(
        name: RouteConstant.chatColorWallpaperScreen,
        page: () => ChatColorWallpaperScreen()),
    GetPage(name: RouteConstant.chatColorScreen, page: () => ChatColorScreen()),
    GetPage(
        name: RouteConstant.chatWallpaperScreen,
        page: () => ChatWallpaperScreen()),
    GetPage(
        name: RouteConstant.wallpaperPreviewScreen,
        page: () => WallpaperPreviewScreen()),
    GetPage(name: RouteConstant.privacyScreen, page: () => PrivacyScreen()),
    GetPage(
        name: RouteConstant.blockedUsersScreen,
        page: () => BlockedUsersScreen()),
    GetPage(
        name: RouteConstant.disappearingScreen, page: () => DisappearScreen()),
    GetPage(
      name: RouteConstant.verifyOtpScreen,
      page: () => VerifyOtpPage(),
    ),
    GetPage(name: RouteConstant.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(
      name: RouteConstant.appearanceScreen,
      page: () => AppearanceScreen(),
    ),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(
      name: RouteConstant.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstant.settingScreen,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: RouteConstant.introScreen,
      page: () => IntroPage(),
    ),
    GetPage(
      name: RouteConstant.chatingScreen,
      page: () => ChatingPage(),
    ),
    GetPage(
      name: RouteConstant.addPhotoScreen,
      page: () => AddPhotoScreen(),
    ),
    GetPage(
      name: RouteConstant.accountScreen,
      page: () => AccountScreen(),
    ),
    GetPage(
      name: RouteConstant.changePinScreen,
      page: () => PinSettingScreen(),
    ),
    GetPage(
      name: RouteConstant.advancePinSetting,
      page: () => AdvancePinSettingScreen(),
    ),
    GetPage(
      name: RouteConstant.changePhoneScreen,
      page: () => ChangePhoneScreen(),
    ),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(
      name: RouteConstant.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstant.settingScreen,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: RouteConstant.helpSettingsScreen,
      page: () => HelpSettingsScreen(),
    ),
    GetPage(
      name: RouteConstant.contactUsScreen,
      page: () => ContactUsScreen(),
    ),
    GetPage(
      name: RouteConstant.licensesScreen,
      page: () => const LicensesScreen(),
    ),
    GetPage(
      name: RouteConstant.chatProfileScreen,
      page: () => ChatProfileScreen(),
    ),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(name: RouteConstant.signInPage, page: () => SignInPage()),
    GetPage(
      name: RouteConstant.verifyOtpScreen,
      page: () => VerifyOtpPage(),
    ),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(name: RouteConstant.homeScreen, page: () => HomeScreen()),
    GetPage(name: RouteConstant.settingScreen, page: () => SettingScreen()),
    GetPage(name: RouteConstant.introScreen, page: () => IntroPage()),
    GetPage(name: RouteConstant.chatingScreen, page: () => ChatingPage()),
    GetPage(name: RouteConstant.addPhotoScreen, page: () => AddPhotoScreen()),
    GetPage(name: RouteConstant.accountScreen, page: () => AccountScreen()),
    GetPage(
        name: RouteConstant.changePinScreen, page: () => PinSettingScreen()),
    GetPage(
        name: RouteConstant.advancePinSetting,
        page: () => AdvancePinSettingScreen()),
    GetPage(
      name: RouteConstant.changePhoneScreen,
      page: () => ChangePhoneScreen(),
    ),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(
      name: RouteConstant.verifyOtpScreen,
      page: () => VerifyOtpPage(),
    ),
    GetPage(
      name: RouteConstant.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstant.settingScreen,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: RouteConstant.helpSettingsScreen,
      page: () => HelpSettingsScreen(),
    ),
    GetPage(
      name: RouteConstant.contactUsScreen,
      page: () => ContactUsScreen(),
    ),
    GetPage(
      name: RouteConstant.licensesScreen,
      page: () => const LicensesScreen(),
    ),
    GetPage(
      name: RouteConstant.chatProfileScreen,
      page: () => ChatProfileScreen(),
    ),
    GetPage(
        name: RouteConstant.changePhoneScreen, page: () => ChangePhoneScreen()),
    GetPage(
        name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),
    GetPage(name: RouteConstant.homeScreen, page: () => HomeScreen()),
    GetPage(name: RouteConstant.settingScreen, page: () => SettingScreen()),
    GetPage(
        name: RouteConstant.helpSettingsScreen,
        page: () => HelpSettingsScreen()),
    GetPage(name: RouteConstant.contactUsScreen, page: () => ContactUsScreen()),
    GetPage(
        name: RouteConstant.licensesScreen, page: () => const LicensesScreen()),
    GetPage(
        name: RouteConstant.chatProfileScreen, page: () => ChatProfileScreen()),
    GetPage(
        name: RouteConstant.attachmentScreen, page: () => AttachmentScreen()),
    GetPage(name: RouteConstant.chatScreen, page: () => ChatScreen()),
    GetPage(
      name: RouteConstant.donateToChatScreen,
      page: () => DonateToChatPage(),
    ),
    GetPage(
      name: RouteConstant.donateScreen,
      page: () => DonatePage(),
    )
  ];
}
