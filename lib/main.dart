import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx_app/SplashScreen/splash_screen.dart';
import 'package:olx_app/utils/my_colors.dart';

import 'HomeScreen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'olx app',
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: MyColors.luckyPoint,foregroundColor: Colors.white),
        primaryColor: Color(0xff2C3A47),
        appBarTheme: AppBarTheme(
          elevation: 0,
            iconTheme: IconThemeData(color:Colors.white,size: 30),
            backgroundColor: MyColors.luckyPoint,
            // Color(0xff2C3A47),
            titleTextStyle:
                TextStyle(fontSize: 24,color: Colors.white , )),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: Colors.white),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null ? HomeScreen(): SplashScreen(),
    );
  }
}
