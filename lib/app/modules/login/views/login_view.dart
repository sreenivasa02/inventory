import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../registration/views/registration_view.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    controller.isLoading.value = true;
                    await controller.login().then((value) {
                      controller.isLoading.value = false;
                    });
                  },
                  child: Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(RegistrationView());
                  },
                  child: Text(
                    'Registration',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.indigo, // Set the background color of the button
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                  // await controller.signInWithGoogle();
                    // Add your onPressed functionality here
                    Get.snackbar('Alert', 'Still developing it, almost there!',backgroundColor: Colors.redAccent ,colorText: Colors.white,titleText: Text('Alert',style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,fontSize: 20),),messageText: Text('Still developing it, almost there!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),));
                    return;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google, color: Colors.white), // Google icon
                      SizedBox(width: 10), // Add spacing between the icon and text
                      Text(
                        "Sign In With Google",
                        style: TextStyle(color: Colors.white, fontSize: 16), // Text styling
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          // Full-screen loader (only wrapped in Obx)
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Lottie.asset('assets/s.json'), // Custom loader
                  ),
                ),
              );
            }
            return SizedBox.shrink(); // Empty widget when not loading
          }),
        ],
      ),
    );
  }
}
