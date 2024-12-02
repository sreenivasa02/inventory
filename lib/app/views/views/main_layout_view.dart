import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_sessions_apps/app/data/util/AppColor.dart';
import 'package:login_sessions_apps/app/modules/category/views/category_view.dart';
import 'package:login_sessions_apps/app/modules/home/controllers/home_controller.dart';
import 'package:login_sessions_apps/app/modules/products/views/products_view.dart';
import 'package:login_sessions_apps/app/modules/reports/views/reports_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/util/base_controller.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/reports/controllers/reports_controller.dart';
class MainLayoutView extends GetView<BaseController> {
  MainLayoutView({Key? key}) : super(key: key);

  final BaseController mainController = Get.put(BaseController());
  final GlobalKey _menuIconKey = GlobalKey();

  void _showCustomDrawer(BuildContext context) {
    RenderBox? renderBox = _menuIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    Offset position = renderBox.localToGlobal(Offset.zero);
    mainController.isDrawerOpen.value = true;

    OverlayEntry drawerOverlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: position.dy + 56,
        left: 0,
        child: GestureDetector(
          onTap: () => mainController.closeDrawer(),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerListTile(index: 0, icon: Icons.home, title: 'Home', mainController: mainController),
                  DrawerListTile(index: 1, icon: Icons.payment_rounded, title: 'Billings', mainController: mainController),
                  DrawerListTile(index: 2, icon: Icons.bar_chart, title: 'Reports', mainController: mainController),
                  DrawerListTile(index: 3, icon: Icons.add_shopping_cart, title: 'Products', mainController: mainController),
                  DrawerListTile(index: 4, icon: Icons.category_outlined, title: 'Category', mainController: mainController),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    mainController.setDrawerOverlayEntry(drawerOverlayEntry);
    Overlay.of(context)?.insert(drawerOverlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /*print(mainController);
      // Lazily initialize controllers based on the selected tab
      if (mainController.selectedTabIndex.value == 1) {
        Get.delete<DashboardController>();
        Get.put(() => DashboardController());
      } else if (mainController.selectedTabIndex.value == 2) {
        Get.delete<ReportsController>();
        Get.put(() => ReportsController().update());
      }else if (mainController.selectedTabIndex.value == 0) {
        Get.delete<HomeController>();
        Get.put(() => HomeController());
      }*/

      return
      Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: mainController.titles[mainController.selectedTabIndex.value],
          menuIconKey: _menuIconKey,
          onMenuPressed: () {
            if (mainController.isDrawerOpen.value) {
              mainController.closeDrawer();
            } else {
              _showCustomDrawer(context);
            }
          },
          onLogoutPressed: mainController.logout,
          username: Get.put(HomeController()).username.value,
          isDrawerOpen: mainController.isDrawerOpen.value,
        ),
      ),
      body: Obx(() {
        // Dynamically render the selected page
        return mainController.pages[mainController.selectedTabIndex.value];
      }),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: mainController.selectedTabIndex.value,
        onTap: mainController.changeTab,
      ),
    );});
  }
}



class DrawerListTile extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final BaseController mainController;

  // Constructor to accept required parameters
  const DrawerListTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        tileColor: mainController.selectedTabIndex.value == index
            ? Colors.black54 // Highlight color for selected item
            : Colors.transparent,
        onTap: () {
          mainController.changeTab(index); // This will close the drawer
        },
      );
    });
  }
}


class CustomAppBar extends StatelessWidget  {
  final String title;
  final GlobalKey menuIconKey;
  final VoidCallback onMenuPressed;
  final VoidCallback onLogoutPressed;
  final String username;
  final bool isDrawerOpen;

  CustomAppBar({
    required this.title,
    required this.menuIconKey,
    required this.onMenuPressed,
    required this.onLogoutPressed,
    required this.username,
    required this.isDrawerOpen,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryColor,
      centerTitle: true,
      title: Text(title),
      leading: IconButton(
        key: menuIconKey,
        icon: Icon(isDrawerOpen ? Icons.close : Icons.menu),
        onPressed: onMenuPressed,
      ),
      actions: [
        Row(
          children: [
            Icon(Icons.account_circle),
            SizedBox(width: 8),
            Text(
              'HI $username!',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: onLogoutPressed,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColor.primaryColor,
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment_rounded),
          label: 'Billings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: 'Category',
        ),
      ],
    );
  }
}






