import 'package:flutter/material.dart';
import 'package:Sublin/screens/stream_provider_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Sublin/services/auth_service.dart';
import './models/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Auth>.value(value: AuthService().userStream),
    ], child: AuthScreen());
  }
}
