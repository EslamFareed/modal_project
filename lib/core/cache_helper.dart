import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> login({
    String? phone,
    String? name,
    String? idNumber,
    required String email,
    required String id,
    required int type,
  }) async {
    await sharedPreferences.setBool("isLogin", true);
    await sharedPreferences.setInt("type", type);

    await sharedPreferences.setString("name", name ?? "");
    await sharedPreferences.setString("phone", phone ?? "");
    await sharedPreferences.setString("id", id);
    await sharedPreferences.setString("idNumber", idNumber ?? "");
    await sharedPreferences.setString("email", email);
  }

  static bool isLogin() => sharedPreferences.getBool("isLogin") ?? false;
  static int getType() => sharedPreferences.getInt("type") ?? 0;

  static String getName() => sharedPreferences.getString("name") ?? "";
  static String getPhone() => sharedPreferences.getString("phone") ?? "";
  static String getId() => sharedPreferences.getString("id") ?? "";
  static String getIdNumber() => sharedPreferences.getString("idNumber") ?? "";
  static String getEmail() => sharedPreferences.getString("email") ?? "";
}
