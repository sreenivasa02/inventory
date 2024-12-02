import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_sessions_apps/app/data/util/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as di;

import '../../../data/util/DatabaseHelper.dart';
class LoginController extends GetxController {
  //TODO: Implement LoginController
  var isLoggedIn = false.obs;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading=false.obs;
  final di.Dio dio = di.Dio();  // For API call (optional)
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and Password are required');
      return;
    }

    var body = {
      "email": username,
      "password": password,
    };

    try {
      print("Sending request to ${ApiEndPoint.loginUrl} with body: $body");

      di.Response response = await dio.post(
        ApiEndPoint.loginUrl,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        String token = response.data['data'].toString();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);


       /* Get.offNamed('/home');*/
        isLoggedIn.value = true;
        Get.offAllNamed('/main');
      } else {
        print("Login failed: ${response.data}");
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      print("Error during login: $e");
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ) {
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', '${googleSignInAuthentication.idToken}');
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Access the user information
        print("Signed in as: ${userCredential.user?.displayName}");
        await prefs.setString('username', '${userCredential.user?.displayName}');
        isLoggedIn.value = true;
        Get.offAllNamed('/main');
      /*  await _firebaseAuth.signInWithCredential(credential);*/
      }
     /* print("Sending request to ${ApiEndPoint.loginUrl} with body: $body");

      di.Response response = await dio.post(
        ApiEndPoint.loginUrl,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        String token = response.data['data'].toString();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);


        *//* Get.offNamed('/home');*//*
        isLoggedIn.value = true;
        Get.offAllNamed('/main');
      } else {
        print("Login failed: ${response.data}");
        Get.snackbar('Error', 'Invalid credentials');
      }*/
    } catch (e) {
      print("Error during login: $e");
      Get.snackbar('Error', 'Something went wrong');
    }
  }


  Future<void> loginSQLite() async {
    final DatabaseHelper _dbHelper = DatabaseHelper();
    var user = await _dbHelper.loginUser(usernameController.text, passwordController.text);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

        await prefs.setString('username', '${user['username']}');
        await prefs.setString('email', '${user['email']}');
        await prefs.setString('role', '${user['roleName']}');
      await prefs.setString('userId', '${user['userId']}');


      //prefs.setString('isLoggedIn', );
      isLoggedIn.value = true;
      Get.offAllNamed('/main');
    } else {
      Get.snackbar("Error", "Invalid username or password");
    }
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


}
