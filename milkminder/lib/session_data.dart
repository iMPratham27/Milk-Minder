

import 'package:shared_preferences/shared_preferences.dart';

class SessionData{
  static bool? isLogin;
  static String? emailId;

  //add data
  static Future<void> storeSessionData({required bool loginData, required String emailId}) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("loginSession", loginData);
    sharedPreferences.setString("email", emailId);

    getSessionData();
  }

  //retreive data
  static Future<void> getSessionData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    isLogin = sharedPreferences.getBool("loginSession") ?? false;
    emailId = sharedPreferences.getString("email") ?? "";
  }

  // Reset session data on logout
  static void resetSessionData() {
    isLogin = false;
    emailId = null;
  }
}