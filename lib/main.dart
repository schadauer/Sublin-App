import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/widgets/waiting_widget.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/stream_providers.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Sublin/services/auth_service.dart';
import 'models/auth_class.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final String appVersion = '1.0.0';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: FutureBuilder<RemoteConfig>(
      future: _setupRemoteConfig(),
      builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
        // print(snapshot.data.getValue('minAppVersion'));
        return snapshot.hasData
            ? MyApp(remoteConfig: snapshot.data)
            : WaitingScreen();
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  final RemoteConfig remoteConfig;
  MyApp({this.remoteConfig});
  @override
  Widget build(BuildContext context) {
    print(remoteConfig.fetch());

    return MultiProvider(providers: [
      StreamProvider<Auth>.value(value: AuthService().userStream),
    ], child: StreamProviders());
  }
}

Future<RemoteConfig> _setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  // Enable developer mode to relax fetch throttling
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    debugMode: true,
  ));
  // await remoteConfig.setDefaults(<String, dynamic>{
  //   'minAppVersion': '1.0.0',
  // });
  await remoteConfig.fetch(expiration: const Duration(seconds: 1));
  return remoteConfig;
}

bool _appRequiresUpdate(String minAppVersion) {
  bool updateRequired = false;
  for (var i = 0; i <= 4; i + 2) {
    // if (int.parse(minAppVersion.substring(i, i + 1)) >=
    //     int.parse(appVersion.substring(i, i + 1))) updateRequired = true;
    // print(minAppVersion.substring(i, i + 1));
  }
  return updateRequired;
}
