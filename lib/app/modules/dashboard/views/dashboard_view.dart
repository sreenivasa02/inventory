import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:login_sessions_apps/app/data/util/AppColor.dart';
import 'package:login_sessions_apps/app/data/util/base_controller.dart';
import 'package:login_sessions_apps/app/modules/new_billings/views/new_billings_view.dart';

import '../../../data/util/DatabaseHelper.dart';

import '../../../utils/constants.dart';
import '../../../views/views/main_layout_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {


  final GlobalKey<ScaffoldState> _dashboardScaffoldKey = GlobalKey<ScaffoldState>();
  // Define from as a property
  DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String passedFrom = Get.arguments?['page'] ??"";
    var mainController = Get.find<BaseController>();
    final DashboardController dashboardController = Get.put(DashboardController());
    print("passedFrom==${passedFrom}");

    return   Scaffold(
      appBar: passedFrom.toString().isNotEmpty?PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          ()=> CustomAppBar(
            title: mainController.titles[passedFrom.toString().isNotEmpty?1:mainController.selectedTabIndex.value],
            menuIconKey: _dashboardScaffoldKey,
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
        ),
      ):null,
      body:Column(children:[
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: dashboardController.searchController,
            decoration: InputDecoration(
              hintText: 'Search by mobile, payment method, or status',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (dashboardController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (dashboardController.filteredBillingData.isEmpty) {
              return Center(child: Text('No results found.'));
            } else {
              return ListView.builder(
                itemCount: dashboardController.filteredBillingData.length,
                itemBuilder: (context, index) {
                  final billing = dashboardController.filteredBillingData[index];

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500 + (index * 150)), // Staggered delay
                    tween: Tween<double>(begin: 0, end: 1), // Animation from 0 to 1
                    curve: Curves.easeInOutCubicEmphasized, // Smooth curve
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value, // Gradual fade-in
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)), // Slide-in from bottom
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: BillingCard(
                              billing: billing,
                              index: index,
                              controller: dashboardController,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          })


          /* Obx(() {
          // Display a loading spinner while data is being fetched
          if (dashboardController.filteredBillingData.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Render the list of bills using ListView.builder
          return Obx(

                  (){
                if (dashboardController.filteredBillingData.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(), // Prevent scroll conflicts
                    shrinkWrap: true, // Wrap content to avoid overflow
                    itemCount: dashboardController.filteredBillingData.value.length,

                    itemBuilder: (context, index) {
                      final billing = dashboardController.filteredBillingData.value[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: BillingCard(billing: billing, index: index,controller: dashboardController),
                      );
                    },
                  ),
                );}
          );
      }),*/
        )]) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:  FloatingActionButton.extended(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          Get.to(NewBillingsView());
        },
        label: const Text('New Billing'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar:passedFrom.isNotEmpty? CustomBottomNavigationBar(
        currentIndex: passedFrom.toString().isNotEmpty?1:mainController.selectedTabIndex.value,
        onTap: mainController.changeTab,
      ):null,
    );

  }
}
