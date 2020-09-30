import 'package:url_launcher/url_launcher.dart';

launchCaller(String phone) async {
  String url = 'tel:$phone';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
