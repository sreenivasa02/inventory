import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {

  final RegistrationController controller = Get.put(RegistrationController());
  final List<String> roles = ["Select", "Employee", "Admin", "Manager"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.registrationFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => controller.validateName(value!),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => controller.validateEmail(value!),
              ),
              SizedBox(height: 10),
             /* TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'User Role'),
                validator: (value) => controller.validateRoleName(value!),
              ),*/
              Obx(
                ()=> DropdownButtonFormField<String>(
                  value:  controller.selectRole.value,
                  onChanged: (value) {

                    controller.selectRole.value = value!;

                  },
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Role'),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => controller.validatePassword(value!),
              ),
              SizedBox(height: 20),
              Obx(
                ()=> ElevatedButton(
                  onPressed: () async {
                    await controller.registerSQLite();
                  },
                  child:controller.isLoading.value?Center(child: const CircularProgressIndicator()): Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
