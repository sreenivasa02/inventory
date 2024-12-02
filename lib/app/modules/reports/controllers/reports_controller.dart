import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;
  var opacityValue = 0.0.obs; // Observable for fade-in effect

  final chartData = [
    {'month': 'September', 'value': 50},
    {'month': 'October', 'value': 80},
    {'month': 'November', 'value': 30},
  ].obs;
  var pieChartData = <ReportData>[].obs; // Observable list for chart data
  var isLoading = true.obs; // To manage loading state
  @override
  void onInit() {
    super.onInit();

    // Initialize the animation controller for sliding effect
    slideController = AnimationController(
      duration: Duration(seconds: 2), // Slow slide-in duration
      vsync: this,
    );

    // Slide animation from left to right (negative X offset to positive)
    slideAnimation = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: slideController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        opacityValue.value = slideAnimation.value.dx == 0.0 ? 1.0 : 0.0;
      });

    // Start sliding animation
    slideController.forward();

    // Set opacity once the animation begins
    Future.delayed(Duration(seconds: 1), () {
      opacityValue.value = 1.0; // Fade-in after the animation starts
    });
    fetchData();
  }

  @override
  void onClose() {
    slideController.dispose();
    super.onClose();
  }

  // Observable data list


  List<double> get values =>
      chartData.map((data) => data['value'] as double).toList();

  List<String> get labels =>
      chartData.map((data) => data['month'] as String).toList();

// Load the data (this could come from an API or local source)
  void fetchData() {
    // Simulating an API call
    Future.delayed(Duration(seconds: 1), () {
      // Example data from the provided JSON
      List<Map<String, dynamic>> jsonData = [
        {"_id": "Debit Card", "method": "Debit Card", "amount": 7535.74},
        {"_id": null, "method": "Others", "amount": 2613.8},
        {"_id": "Cash", "method": "Cash", "amount": 22592.3},
        {"_id": "UPI", "method": "UPI", "amount": 15944.99},
        {"_id": "Credit Card", "method": "Credit Card", "amount": 21375.79}
      ];

      // Parse JSON data
     pieChartData.value = jsonData.map((item) => ReportData.fromJson(item)).toList();
      isLoading.value = false; // Data loaded
    });
  }
}
class ChartData {
  final String month;
  final int value;

  ChartData(this.month, this.value);
}
class ReportData {
  final String method;
  final double amount;

  ReportData({required this.method, required this.amount});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      method: json['method'] ?? 'Unknown',
      amount: json['amount'].toDouble(),
    );
  }
}