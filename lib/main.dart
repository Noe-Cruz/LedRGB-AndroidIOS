import 'package:appcontrolled/firebase_options.dart';
import 'package:appcontrolled/pages/home.dart';
import 'package:appcontrolled/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App Control",
      initialRoute: 'Home',
      routes: {
        'Home': (context) => const Home(),
      },
    );
  }
}




