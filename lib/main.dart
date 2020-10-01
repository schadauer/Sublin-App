import 'package:Sublin/models/versioning_class.dart';
import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/services/versioning_service.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/stream_providers.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Sublin/services/auth_service.dart';
import 'models/auth_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> packageInfo) {
        return packageInfo.data != null
            ? MyApp(packageInfo: packageInfo.data)
            : WaitingScreen(
                title: 'Sublin, auf geht\'s',
              );
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  final PackageInfo packageInfo;
  MyApp({this.packageInfo});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Auth>.value(value: AuthService().userStream),
      StreamProvider<Versioning>.value(
          initialData: null, value: VersioningService().streamVersioning()),
    ], child: StreamProviders());
  }
}
