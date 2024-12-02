import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewBillingsController extends GetxController {
  //TODO: Implement NewBillingsController
  // Controller for the search TextField
  final TextEditingController searchNewBillingController = TextEditingController();

  // Original list of items
  final List<String> items = [
    'Mobile - 1234567890',
    'Card Payment - Paid',
    'UPI Payment - Pending',
    'Net Banking - Paid',
  ];

  // Observable list for filtered suggestions
  var filteredSuggestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredSuggestions.value = items;
    searchNewBillingController.addListener(() {
      filterSuggestions(searchNewBillingController.text);
    });
  }
// Filter suggestions based on the query
  void filterSuggestions(String query) {
    if (query.isEmpty) {
      filteredSuggestions.value = [];
    } else {
      filteredSuggestions.value = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
