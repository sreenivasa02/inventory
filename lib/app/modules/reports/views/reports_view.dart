import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  ReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ReportsController _controller = Get.put(ReportsController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0,left: 12,right: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  buildCard(
                      "Hello World!",
                      Duration(milliseconds: 200),
                      Colors.white54.withOpacity(0.1), // Dynamic background color
                      Colors.black87, // Dynamic text color
                      Colors.blue.withOpacity(0.9) // Dynamic border color
                  ),
                  SizedBox(height: 8),
                  buildCard(
                      "Srinivas!",
                      Duration(milliseconds: 400),
                      Colors.white54.withOpacity(0.1),
                      Colors.black87,
                      Colors.green.withOpacity(0.9)
                  ),
                  SizedBox(height: 8),
                  buildCard(
                      "ramlaxman!",
                      Duration(milliseconds: 600),
                      Colors.white54.withOpacity(0.1),
                      Colors.black87,
                      Colors.red.withOpacity(0.9)
                  ),
                ],
              ),

              Container(
                height: Get.height*0.5,
                child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SfCircularChart(
                    title: ChartTitle(text: 'Payment Methods'),
                    legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                      position: LegendPosition.bottom,
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries>[
                      PieSeries<ReportData, String>(
                        dataSource: _controller.pieChartData.value,
                        xValueMapper: (ReportData data, _) => data.method,
                        yValueMapper: (ReportData data, _) => data.amount,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      ),
                    ],
                  ),
                );
              }),
                  ),
              Container(
                height: Get.height*0.5,
                child: Obx(() {
                  // Convert the chart data for the chart series
                  final chartSeriesData = _controller.chartData
                      .map((data) => ChartData(
                      data['month'] as String, data['value'] as int))
                      .toList();

                  // Define custom colors with high transparency
                  final colors = [
                    Colors.blue.withOpacity(0.6), // Blue with transparency
                    Colors.green.withOpacity(0.6), // Green with transparency
                    Colors.orange.withOpacity(0.6), // Orange with transparency
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      title: ChartTitle(text:"Past 3 Months Billing Amount" ),
                      primaryXAxis: CategoryAxis(title: AxisTitle(text:'Billing Amount')),
                      primaryYAxis: NumericAxis(title: AxisTitle(text:'Amount (₹)')),
                      series: <ChartSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: chartSeriesData,
                          xValueMapper: (ChartData data, _) => data.month,
                          yValueMapper: (ChartData data, _) => data.value,
                          width: 0.4, // Very thin bars
                          pointColorMapper: (ChartData data, index) =>
                          colors[index % colors.length],
                          name: 'Sales',
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true, // Show value labels
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildCard(String text, Duration delay, Color backgroundColor, Color textColor, Color shadowColor) {
    return Animate(
      effects: [FadeEffect(), ScaleEffect()],
      delay: delay,
      child: Card(
        elevation: 8,
        shadowColor:shadowColor ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners for card
        ),
        child: Container(
          width: Get.width, // Full width of the screen
          height: 100, // Fixed height
          decoration: BoxDecoration(
            color: backgroundColor, // Dynamic background color
            borderRadius: BorderRadius.circular(16), // Rounded corners for container
           // border: Border.all(color: borderColor), // Dynamic border color
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor, // Dynamic text color
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRotationWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const CustomRotationWidget({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Using Transform.rotate to apply custom rotation
        return Card(
          elevation: 5,
          child: Transform.rotate(
            angle: animation.value *
                2 *
                3.141592653589793, // Convert value to radians
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String text;
  final Color color;

  const CustomContainer({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
