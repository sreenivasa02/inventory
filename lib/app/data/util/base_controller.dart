import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_sessions_apps/app/views/views/main_layout_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/category/views/category_view.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/products/views/products_view.dart';
import '../../modules/reports/views/reports_view.dart';
import 'MasterNetworkService.dart';

class BaseController extends GetxController {
  // Observable variables for drawer state and selected index
  var isDrawerOpen = false.obs;
  var selectedIndex = 0.obs;
  var isLoggedIn = false.obs;
  var username = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var userId = ''.obs;
  final List<String> titles = [
    'Home',
    'Billings',
    'Reports',
    'Products',
    'Category',
  ];
  final List<Widget> pages = [
    HomeView(key: UniqueKey()),
    DashboardView(key: UniqueKey()),
    ReportsView(key: UniqueKey()),
    ProductsView(key: UniqueKey()),
    CategoryView(key: UniqueKey()),
  ];
  // Toggle the drawer's open/close state
  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }
  Future<void> getPreferences() async {
    await MasterNetWorkService().startMasterServices(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    email.value = prefs.getString('email') ?? '';
    role.value = prefs.getString('role') ?? '';
    userId.value = prefs.getString('userId') ?? '';
  }
  OverlayEntry? _drawerOverlayEntry;

  void setDrawerOverlayEntry(OverlayEntry entry) {
    _drawerOverlayEntry = entry;
  }

  void closeDrawer() {
    isDrawerOpen.value = false;
    _drawerOverlayEntry?.remove();
    _drawerOverlayEntry = null;
  }


  void changeTab(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (JwtDecoder.isExpired(token)) {
      isLoggedIn.value=true;
      Get.offAllNamed('/login');
    } else {
      if (selectedTabIndex.value != index) { // Prevent redundant updates
        selectedTabIndex.value = index;
        Get.to(MainLayoutView());
      } else {
        selectedTabIndex.value = index;
        Get.to(MainLayoutView());
      }
      closeDrawer(); // Close drawer whenever the tab changes
    }
  }
  // Logout function to clear login status and navigate to login page
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //await prefs.setBool('isLoggedIn', false); // Clear the login status
    Get.offAllNamed('/login'); // Navigate to the login page
  }
  // Observes the selected index for bottom navigation
  var selectedTabIndex = 0.obs;

  @override
  void onClose() {
    super.onClose();
    // Explicitly delete the controller when no longer needed

  }
}
