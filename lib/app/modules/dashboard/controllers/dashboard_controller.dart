import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:login_sessions_apps/app/data/util/base_controller.dart';

import '../../../data/util/MasterNetworkService.dart';

class DashboardController extends GetxController {
  var expandedStates = <bool>[].obs; // Stores the expanded state of each item
  var billingData = <dynamic>[].obs; // Billing data, kept dynamic for flexibility
  var isLoading = false.obs; // Tracks loading state
  var errorMessage = ''.obs; // Tracks error messages
  var filteredBillingData = <dynamic>[].obs; // Filtered billing data for search
  TextEditingController searchController = TextEditingController(); // Search bar controller

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  Future<void> fetchBills() async {
    isLoading.value = true; // Show loading state
    errorMessage.value = ''; // Reset error message

    try {
      // Call the service to get the recent bills
      var response = await MasterNetWorkService().getAllTransactionMasterServices();

      if (response != null && response is List) {
        // Assign response to billing data
        billingData.assignAll(response);

        // Synchronize expanded states with the number of bills
        expandedStates.assignAll(List.filled(billingData.length, false));
        filteredBillingData.assignAll(billingData);

        // Listen to changes in the search field
        searchController.addListener(() {
          filterBillingData(searchController.text);
        });
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

  void setExpandedState(int index, bool isExpanded) {
    if (index >= 0 && index < expandedStates.length) {
      expandedStates[index] = isExpanded;
    }
  }

  void filterBillingData(String query) {
    if (query.isEmpty) {
      filteredBillingData.assignAll(billingData);
    } else {
      filteredBillingData.assignAll(
        billingData.where((billing) {
          // Ensure the billing item is a Map<String, dynamic> before filtering
          if (billing is Map<String, dynamic>) {
            final mobile = billing['customerMobile']?.toString() ?? '';
            final paymentMethod = billing['paidVia']?.toString()?.toLowerCase() ?? '';
            final paymentStatus = billing['paymentStatus']?.toString()?.toLowerCase() ?? '';

            return mobile.contains(query) ||
                paymentMethod.contains(query.toLowerCase()) ||
                paymentStatus.contains(query.toLowerCase());
          }
          return false; // Exclude non-map items
        }).toList(),
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose(); // Dispose the controller
    super.onClose();
  }
}
