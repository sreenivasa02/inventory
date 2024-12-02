import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:login_sessions_apps/app/data/util/base_controller.dart';
import 'package:login_sessions_apps/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:login_sessions_apps/app/modules/dashboard/views/dashboard_view.dart';
import 'package:login_sessions_apps/app/modules/new_billings/views/new_billings_view.dart';
import 'package:login_sessions_apps/app/modules/products/views/products_view.dart';
import 'package:login_sessions_apps/app/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../../views/views/main_layout_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final HomeController homeController = Get.put(HomeController());
  final GlobalKey<ScaffoldState> homeScaffoldKey =
      GlobalKey<ScaffoldState>(); // Register controller once here

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //key: homeScaffoldKey,
        /* appBar:AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: homeController.logout,
          ),
        ],
       */ /* onMenuTap: homeController.toggleDrawer,
        onLogoutTap: homeController.logout,*/ /*
      ),*/
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Expanded Widget
                    Expanded(
                      child: homeController.isLoading.value
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: buildCardContent(),
                      )
                          : buildCardContent(),
                    ),
                    SizedBox(width: 10), // Add spacing between the widgets
                    Expanded(
                      child: homeController.isLoading.value
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: buildQuickActions(),
                      )
                          : buildQuickActions(),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 20,),


            Expanded(
              child: Obx(
                    () {
                      if (homeController.billingData.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }
                  return Card(
                    elevation: 5,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (left)
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spread items across the row
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0), // Add some spacing
                                  child: Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                      fontSize: 19, // Slightly larger font size
                                      fontWeight: FontWeight.bold, // Make it bold
                                      color: Colors.indigo, // Attractive color
                                      /*shadows: [
                      Shadow(
                        offset: Offset(1.5, 1.5), // Adds depth
                        blurRadius: 3.0,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ],*/
                                      letterSpacing: 1.2, // Adds spacing between letters
                                    ),
                                    textAlign: TextAlign.left, // Ensure left alignment
                                  ),
                                ),
                              ), // Placeholder to align the button to the right
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(
                                  onPressed: () {

                                    //GetPage(name: '/dashboard', page: () => DashboardView());
                                    Get.delete<DashboardController>();
                                 Get.put(BaseController()).isLoggedIn.value?Get.offAllNamed('/login') :  Get.to(() => DashboardView(),arguments: {'page':'home'},transition: Transition.noTransition,);


                                    /*Get.toNamed(
                                      '/dashboard',
                                      arguments: {'from': 'home'},
                                    );*/
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Shrink to fit content
                                    children: [
                                      Text(
                                        "View All Transactions",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 4), // Space between text and icon
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_outlined, // Double arrow icon
                                            color: Colors.blue,
                                            size: 16, // Small size for icon
                                          ), Icon(
                                            Icons.arrow_forward_ios_outlined, // Double arrow icon
                                            color: Colors.blue,
                                            size: 16, // Small size for icon
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(), // Prevent scroll conflicts
                            shrinkWrap: true, // Wrap content to avoid overflow
                            itemCount: /*homeController.billingData.value.length > 4
                                ? 4 // Show only the first four items
                                : */homeController.billingData.value.length,
                            itemBuilder: (context, index) {
                              final billing = homeController.billingData.value[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: BillingCard(billing: billing, index: index,controller:homeController ),
                              );
                            },
                          ),

                        ],
                      )

                    ),
                  );
                },
              ),
            ),
          ],
        ),);
  }
  Widget buildCardContent() {
    return   Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           /* Icon(
              Icons.calendar_today,
              size: 25,
              color: Colors.blue,
            ),
            SizedBox(height: 5),
            Text(
              DateFormat('dd/MMM/yyyy').format(DateTime.now()),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),*/
            SizedBox(height: 20),
            buildDataRow("Today's Bills", "₹ ${homeController.billingDataToday.value.isEmpty?"0":homeController.billingDataMonthly[0]['totalBillings']}", Colors.green),
            SizedBox(height: 10),
            buildDataRow(
                "Today's Amount", "₹ ${homeController.billingDataToday.value.isEmpty?"0":homeController.billingDataMonthly[0]['totalAmount']}", Colors.green),
            SizedBox(height: 20),
            buildDataRow(
                "Monthly's Bills", "₹ ${homeController.billingDataMonthly.value.isEmpty?"0":homeController.billingDataMonthly[0]['totalBillings']}", Colors.orange),
            SizedBox(height: 10),
            buildDataRow(
                "Monthly's Amount", "₹ ${homeController.billingDataMonthly.value.isEmpty?"0":homeController.billingDataMonthly[0]['totalAmount']}", Colors.orange),
          ],
        ),
      ),
    );
  }
  Widget buildQuickActions() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            buildActionButton(
              "New Billing",
              Icons.receipt_long,
              Colors.blue,
                  () { Get.delete<DashboardController>();
                  Get.put(BaseController()).isLoggedIn.value?Get.offAllNamed('/login') :  Get.to(() => DashboardView(),arguments: {'page':'home'},transition: Transition.noTransition,);}

            ),
            SizedBox(height: 10),
            buildActionButton(
              "Add Product",
              Icons.add_shopping_cart,
              Colors.green,
                  () => print("Add Product pressed!"),
            ),
            SizedBox(height: 10),
            buildActionButton(
              "Add Category",
              Icons.category,
              Colors.orangeAccent,
                  () => print("Add Category pressed!"),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildDataRow(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class BillingCard extends StatelessWidget {
  final Map<String, dynamic> billing;
  final int index;
  final dynamic controller;

  BillingCard({required this.billing, required this.index,required this.controller});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              billing['productsList'][0]['productName'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              billing['paymentStatus'],
              style: TextStyle(
                color: billing['paymentStatus'] == 'Success'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
           
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Customer Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Custom color for 'Customer Name'
                          ),
                        ),
                        Text('${billing['customerName']}'),
                      ],
                    ),
                    SizedBox(width: 20), // Add space between columns

                    // Mobile
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Custom color for 'Mobile'
                          ),
                        ),
                        Text('${billing['customerMobile']}'),
                      ],
                    ),
                    SizedBox(width: 20),

                    // Email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange, // Custom color for 'Email'
                          ),
                        ),
                        SizedBox(
                          width: Get.width*  0.25,
                          child: Text('${billing['customerEmail']}', maxLines: 2,style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Total Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple, // Custom color for 'Total Price'
                          ),
                        ),
                        Text('₹${billing['totalPrice']}'),
                      ],
                    ),
                    SizedBox(width: 20),

                    // Final Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Final Price: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // Custom color for 'Final Price'
                          ),
                        ),
                        Text('₹${billing['finalPrice']}'),
                      ],
                    ),
                    SizedBox(width: 20),

                    // Paid Via
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paid Via: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal, // Custom color for 'Paid Via'
                          ),
                        ),
                        Text('${billing['paidVia']}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )






        ],
        onExpansionChanged: (bool expanded) {
          controller.setExpandedState(index, expanded);
        },
        initiallyExpanded: controller.expandedStates[index],
      ),
    );
  }
}


class BouncingExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const BouncingExpansionTile({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    Key? key,
  }) : super(key: key);

  @override
  _BouncingExpansionTileState createState() => _BouncingExpansionTileState();
}

class _BouncingExpansionTileState extends State<BouncingExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Bounce effect
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  void _toggleExpansion() {
    setState(() {
      if (_isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isExpanded = !_isExpanded;
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleExpansion,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.title,
            ),
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: _isExpanded
                  ? Column(
                children: widget.children,
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
