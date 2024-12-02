import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

import '../../../data/util/DatabaseHelper.dart';
import '../../../data/util/api_endpoints.dart';
import '../../../data/util/master_service_repository.dart';
import '../../../data/util/master_service_repository_impl.dart';
class RegistrationController extends GetxController {
  // Form Key for validation
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleName = TextEditingController();
  RxBool isLoading=false.obs;
  RxString userId=''.obs;
  final di.Dio dio = di.Dio();  // For API call (optional)
  // Observable variables for form data
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var selectRole = 'Select'.obs;



  // Validator for name
  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    return null;
  }

  // Validator for email
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide a valid email";
    }
    return null;
  }

  // Validator for password
  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateRoleName(String value) {
    if (value.isEmpty) {
      return "Please Select Role Name";
    }
    return null;
  }
    Future<void> registerSQLite() async {
      MasterServiceRepositoryImpl masterServiceRepository = Get.put(MasterServiceRepositoryImpl());
    final random = Random();
    int uniqueId = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    userId.value= uniqueId.toString();
    print("0000${selectRole.value}");
    final DatabaseHelper _dbHelper = DatabaseHelper();
    await _dbHelper.registerUser(username: nameController.text, password: passwordController.text,email: emailController.text,roleName: selectRole.value,userId: userId.value);



     var response= await masterServiceRepository.registration({

       "email": emailController.text,
       "password" : passwordController.text
     },ApiEndPoint.registrationUrl);
     print("response===${response.statusCode}");
     if(response.statusCode == 200){
    Get.snackbar("Success", "Registration successful");
    Get.offAllNamed('/login');
     }else{
       Get.snackbar("Error", "${response['data']}");
       Get.offAllNamed('/registration');
     }
  }

  String generateUserId() {
    final random = Random();
    int uniqueId = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    return uniqueId.toString();
  }

// Usage example in a register button click
  void onRegisterButtonClick() {


  }

  // Clear controllers on dispose
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    Get.delete<RegistrationController>();
    super.onClose();
  }
}
