import 'dart:convert';
import 'package:todo_app/core/models/auth_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
const String isLoggedIn = "IsLoggedIn";
const String loginResponse = "LoginResponse";

Future<void> initSharedPref() async {
  sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getBool(isLoggedIn) == null) {
    sharedPreferences.setBool(isLoggedIn, false);
  }
}

Future<void> setIsLoggedIn(bool val) async {
  await sharedPreferences.setBool(isLoggedIn, val);
}

bool getIsLoggedIn() {
  return (sharedPreferences.getBool(isLoggedIn) ?? false);
}

Future<void> setLoginResponse(AuthDataModel? model) async {
  await sharedPreferences.setString(loginResponse, jsonEncode(model));
}

AuthDataModel? get getLoginResponse {
  final data = sharedPreferences.getString(loginResponse);
  if (data != null) {
    return AuthDataModel.fromJson(jsonDecode(data));
  }
  return null;
}

Future<void> removeLoginResponse() async {
  await setLoginResponse(null);
  await sharedPreferences.remove(loginResponse);
}