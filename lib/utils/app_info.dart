class AppInfo {
  String version = "1.0.0";

  static Future<AppInfo> init() async {
    return AppInfo();
  }
}