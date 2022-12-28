import 'package:shared_preferences/shared_preferences.dart';

class helperFunction {
  static String userLoginKey = "userLoginkey";
  static String userNameKey = "userNameKey";
  static String userEmailKey = "userEmailKey";

  //saving data to SP
  static Future<bool> svaeUserLogedInstatus(bool isUserLogedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoginKey, isUserLogedIn);
  }

  static Future<bool> svaeUserName(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> svaeUseremail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  //Retriving data from SP
  static Future<bool?> getUserLogedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoginKey);
  }

  static Future<String?> getUserEmailSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
