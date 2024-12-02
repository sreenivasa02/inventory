import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_sessions_apps/app/data/util/MasterNetworkService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/util/base_controller.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  // Observables for managing state
  var expandedStates = <bool>[].obs; // Stores the expanded state of each item
  var billingData = <dynamic>[].obs;
  var billingDataToday = <dynamic>[].obs;
  var billingDataMonthly = <dynamic>[].obs; // Replace dynamic with your specific model type if known
  var isLoading = false.obs; // Tracks loading state
  var errorMessage = ''.obs; // Tracks error messages
RxBool isLogin=false.obs;
  var username = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var userId = ''.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    getPreferences();
     fetchBills();
    fetchBilssToady();
    fetchBillsMonthly();
  }

  Future<void> getPreferences() async {
    await MasterNetWorkService().startMasterServices(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    email.value = prefs.getString('email') ?? '';
    role.value = prefs.getString('role') ?? '';
    userId.value = prefs.getString('userId') ?? '';
  }
  /// Sets the expanded state for an item
  void setExpandedState(int index, bool isExpanded) {
    if (index >= 0 && index < expandedStates.length) {
      expandedStates[index] = isExpanded;
    }
  }

  /// Fetches the list of recent bills
  Future<void> fetchBills() async {
    isLoading.value = true; // Show loading state
    errorMessage.value = ''; // Reset error message

    try {
      // Call the service to get the recent bills
       var response= await  MasterNetWorkService().getRecentBillsMasterServices();


      if (response != null && response is List) {
        // Assign response to billing data
        billingData.assignAll(response);

        // Synchronize expanded states with the number of bills
        expandedStates.assignAll(List.filled(billingData.length, false));
      } else {
        // Handle unexpected response format
        errorMessage.value = "Unexpected response format.";
        print("Unexpected response format: $response");
      }
    } catch (e) {
      // Handle any exceptions or errors
      errorMessage.value = "Failed to fetch bills. Please try again.";
      print("Error fetching bills: $e");
    } finally {
      isLoading.value = false; // Hide loading state
    }
  }
  Future<void> fetchBilssToady() async {
    isLoading.value = true; // Show loading state
    errorMessage.value = ''; // Reset error message

    try {
      // Call the service to get the recent bills
      var response= await  MasterNetWorkService().getfetchbillingsToday();


      if (response != null && response is List) {
        // Assign response to billing data
        billingDataToday.assignAll(response);
        print("billingDataToday-----$billingDataToday");

        // Synchronize expanded states with the number of bills
        //expandedStates.assignAll(List.filled(billingData.length, false));
      } else {
        // Handle unexpected response format
        errorMessage.value = "Unexpected response format.";
        print("Unexpected response format: $response");
      }
    } catch (e) {
      // Handle any exceptions or errors
      errorMessage.value = "Failed to fetch bills. Please try again.";
      print("Error fetching bills: $e");
    } finally {
      isLoading.value = false; // Hide loading state
    }
  }
  Future<void> fetchBillsMonthly() async {
    isLoading.value = true; // Show loading state
    errorMessage.value = ''; // Reset error message

    try {
      // Call the service to get the recent bills
      var response= await  MasterNetWorkService().getfetchbillingsMonthly();


      if (response != null && response is List) {
        // Assign response to billing data
        billingDataMonthly.assignAll(response);
        print("billingDataMonthly-----${billingDataMonthly[0]['totalAmount']}");
        print("billingDataMonthly-----${billingDataMonthly[0]['totalBillings']}");

        // Synchronize expanded states with the number of bills
       // expandedStates.assignAll(List.filled(billingData.length, false));
      } else {
        // Handle unexpected response format
        errorMessage.value = "Unexpected response format.";
        print("Unexpected response format: $response");
      }
    } catch (e) {
      // Handle any exceptions or errors
      errorMessage.value = "Failed to fetch bills. Please try again.";
      print("Error fetching bills: $e");
    } finally {
      isLoading.value = false; // Hide loading state
    }
  }
}

