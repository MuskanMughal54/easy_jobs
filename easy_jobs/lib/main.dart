import 'package:easy_jobs/global_state.dart';
import 'package:easy_jobs/screens/home_screen.dart';
import 'package:easy_jobs/screens/registeration_screen.dart';
import 'package:easy_jobs/screens/screens.dart';
import 'package:easy_jobs/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => GlobalState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterationScreen(),
        '/profile': (context) => const ProfileScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
