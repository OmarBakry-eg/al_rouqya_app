import 'dart:ffi';

import 'package:animated_splash/animated_splash.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplash(
        imagePath: 'assets/s.jpg',
        home: MyHomePage(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}
