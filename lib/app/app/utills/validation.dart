class ValidationUtil{

  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z]+$');

  static bool validateName(String username) {
    return usernameRegex.hasMatch(username);
  }

}