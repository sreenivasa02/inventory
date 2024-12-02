import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:login_sessions_apps/app/modules/login/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'app/views/views/main_layout_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for existing token in shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // Determine the initial route
  String initialRoute = determineInitialRoute(token);
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp(initialRoute: initialRoute));
}

String determineInitialRoute(String? token) {
  if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
    return '/login';
  }
  return '/main';
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await validateToken();
    }
  }

  Future<void> validateToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || JwtDecoder.isExpired(token)) {
      Get.offAllNamed('/login'); // Redirect to login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: widget.initialRoute,
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/main', page: () => MainLayoutView()),
      ],
    );
  }
}

