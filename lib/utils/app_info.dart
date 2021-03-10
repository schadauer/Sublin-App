class AppInfo {
  String version = "1";

  static Future<AppInfo> init() async {
    return AppInfo();
  }
}