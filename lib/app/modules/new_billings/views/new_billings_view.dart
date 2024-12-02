import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:login_sessions_apps/app/views/views/main_layout_view.dart';

import '../../../data/util/base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/new_billings_controller.dart';

class NewBillingsView extends GetView<NewBillingsController> {
  const NewBillingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final BaseController mainController = Get.put(BaseController());
     NewBillingsController newBillingsController = Get.put(NewBillingsController());

    final GlobalKey newBillingsView = GlobalKey();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'New Billing.......',//mainController.titles[mainController.selectedTabIndex.value],
          menuIconKey: newBillingsView,
          onMenuPressed: () {
            if (mainController.isDrawerOpen.value) {
              mainController.closeDrawer();
            } else {
             // _showCustomDrawer(context);
            }
          },
          onLogoutPressed: mainController.logout,
          username: Get.put(HomeController()).username.value,
          isDrawerOpen: mainController.isDrawerOpen.value,
        ),
      ),/*AppBar(
        title: const Text('NewBillingsView'),
        centerTitle: true,
      )*/
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search TextField
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
                    child: TextField(
                      controller: newBillingsController.searchNewBillingController,
                      decoration: InputDecoration(
                        hintText: 'Search by mobile, payment method, or status',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),

                  // Suggestions List
                  Obx(() {
                    if (newBillingsController.filteredSuggestions.isEmpty) {
                      return SizedBox(); // Hide the list if there are no suggestions
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: newBillingsController.filteredSuggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(newBillingsController.filteredSuggestions[index]),
                            onTap: () {
                              // Handle selection
                              print('Selected: ${newBillingsController.filteredSuggestions[index]}');
                              newBillingsController.searchNewBillingController.text =
                              newBillingsController.filteredSuggestions[index];
                              newBillingsController.filteredSuggestions.value = []; // Clear suggestions
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Text(
            'NewBillingsView is working',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex:mainController.selectedTabIndex.value,
        onTap: mainController.changeTab,
      ),
    );
  }
}
