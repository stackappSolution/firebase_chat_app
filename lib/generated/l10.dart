// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
    'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
    'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }
  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Calls`
  String get calls {
    return Intl.message(
      'Calls',
      name: 'calls',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Linked Devices`
  String get linkedDevice {
    return Intl.message(
      'Linked Devices',
      name: 'linkedDevice',
      desc: '',
      args: [],
    );
  }

  /// `Donate To Signal`
  String get donateToSignal {
    return Intl.message(
      'Donate To Signal',
      name: 'donateToSignal',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Invite Friends`
  String get inviteFriends {
    return Intl.message(
      'Invite Friends',
      name: 'inviteFriends',
      desc: '',
      args: [],
    );
  }

  /// `Gujarati`
  String get gujarati {
    return Intl.message(
      'Gujarati',
      name: 'gujarati',
      desc: '',
      args: [],
    );
  }
  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Your Profile`
  String get yourProfile {
    return Intl.message(
      'Your Profile',
      name: 'yourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Profiles Are Visible To People You Message,Contacts, and Groups.`
  String get profileAreVisible {
    return Intl.message(
      'Profiles Are Visible To People You Message,Contacts, and Groups.',
      name: 'profileAreVisible',
      desc: '',
      args: [],
    );
  }

  /// `First Name ( Required )`
  String get firstName {
    return Intl.message(
      'First Name ( Required )',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name ( Required )`
  String get lastName {
    return Intl.message(
      'Last Name ( Required )',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Name`
  String get enterValidName {
    return Intl.message(
      'Enter Valid Name',
      name: 'enterValidName',
      desc: '',
      args: [],
    );
  }

  /// `choose`
  String get choose {
    return Intl.message(
      'choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Chat Color & wallpaper`
  String get chatColor {
    return Intl.message(
      'Chat Color & wallpaper',
      name: 'chatColor',
      desc: '',
      args: [],
    );
  }

  /// `App Icon`
  String get appIcon {
    return Intl.message(
      'App Icon',
      name: 'appIcon',
      desc: '',
      args: [],
    );
  }

  /// `Message Font Size`
  String get messageFontSize {
    return Intl.message(
      'Message Font Size',
      name: 'messageFontSize',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Navigation Bar Size`
  String get navigationBarSize {
    return Intl.message(
      'Navigation Bar Size',
      name: 'navigationBarSize',
      desc: '',
      args: [],
    );
  }

  /// `Transfer or Restore Account`
  String get transferOrRestoreAccount {
    return Intl.message(
      'Transfer or Restore Account',
      name: 'transferOrRestoreAccount',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Privacy Policy`
  String get termsPrivacyPolicy {
    return Intl.message(
      'Terms & Privacy Policy',
      name: 'termsPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// ` Welcome To Chat`
  String get welcomeToChat {
    return Intl.message(
      ' Welcome To Chat',
      name: 'welcomeToChat',
      desc: '',
      args: [],
    );
  }

  /// `The best messenger and chat`
  String get theBestMessengerAndChat {
    return Intl.message(
      'The best messenger and chat',
      name: 'theBestMessengerAndChat',
      desc: '',
      args: [],
    );
  }

  /// `to make your day great!`
  String get toMakeYourDayGreat {
    return Intl.message(
      'to make your day great!',
      name: 'toMakeYourDayGreat',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone Number To Get Started`
  String get signInDescription {
    return Intl.message(
      'Enter Your Phone Number To Get Started',
      name: 'signInDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter The Code We Sent To`
  String get verifyOtp {
    return Intl.message(
      'Enter The Code We Sent To',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verifyButton {
    return Intl.message(
      'Verify',
      name: 'verifyButton',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verify {
    return Intl.message(
      'Verify OTP',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Signal message`
  String get signalMessage {
    return Intl.message(
      'Signal message',
      name: 'signalMessage',
      desc: '',
      args: [],
    );
  }

  /// `121`
  String get oneTwoOne {
    return Intl.message(
      '121',
      name: 'oneTwoOne',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Signal`
  String get signal {
    return Intl.message(
      'Signal',
      name: 'signal',
      desc: '',
      args: [],
    );
  }

  /// `Search..`
  String get search {
    return Intl.message(
      'Search..',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `New Group`
  String get newGroup {
    return Intl.message(
      'New Group',
      name: 'newGroup',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Licenses`
  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
      desc: '',
      args: [],
    );
  }

  /// `Whats this?`
  String get whatsThis {
    return Intl.message(
      'Whats this?',
      name: 'whatsThis',
      desc: '',
      args: [],
    );
  }

  /// `Support center`
  String get supportCenter {
    return Intl.message(
      'Support center',
      name: 'supportCenter',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Somethings Not Working`
  String get somethingNotWorking {
    return Intl.message(
      'Somethings Not Working',
      name: 'somethingNotWorking',
      desc: '',
      args: [],
    );
  }

  /// `Feature Request`
  String get featureRequest {
    return Intl.message(
      'Feature Request',
      name: 'featureRequest',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Debug log`
  String get debugLog {
    return Intl.message(
      'Debug log',
      name: 'debugLog',
      desc: '',
      args: [],
    );
  }

  /// `Include Debug Log`
  String get includeDebug {
    return Intl.message(
      'Include Debug Log',
      name: 'includeDebug',
      desc: '',
      args: [],
    );
  }

  /// `Have you read our FAQ yet?`
  String get readFaq {
    return Intl.message(
      'Have you read our FAQ yet?',
      name: 'readFaq',
      desc: '',
      args: [],
    );
  }

  /// `Tell us wht you are reaching out.`
  String get tellUs {
    return Intl.message(
      'Tell us wht you are reaching out.',
      name: 'tellUs',
      desc: '',
      args: [],
    );
  }

  /// `Copyright Signal Messenger \n Licensed under the GNU AGPlv3`
  String get helpDescription {
    return Intl.message(
      'Copyright Signal Messenger \n Licensed under the GNU AGPlv3',
      name: 'helpDescription',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Privacy Policy`
  String get terms {
    return Intl.message(
      'Terms & Privacy Policy',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message(
      'Contact us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Mark all read`
  String get markAllRead {
    return Intl.message(
      'Mark all read',
      name: 'markAllRead',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'gu', countryCode: 'IN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}