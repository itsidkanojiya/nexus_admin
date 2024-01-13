import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/module/teacher/teacher_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final List<ChartData> chartData = [
    ChartData(2009, 0),
    ChartData(2010, 35),
    ChartData(2011, 28),
    ChartData(2012, 34),
    ChartData(2013, 32),
    ChartData(2014, 40)
  ];
  var controller = Get.isRegistered<TeacherController>()
      ? Get.find<TeacherController>()
      : Get.put(TeacherController());
  @override
  Widget build(BuildContext context) {
    return AppLayout(
        content: SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NumberContainer(
                text: 'Total Users',
              ),
              NumberContainer(
                text: 'Total Teacher',
              ),
              NumberContainer(
                text: 'Monthly Users',
              ),
              NumberContainer(
                text: 'Daily Users',
              ),
            ],
          ),
          SizedBox(
            height: Styles.defaultPadding,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      AreaSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) =>
                              data.x.toString(),
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              // Positioning the data label
                              labelAlignment: ChartDataLabelAlignment.top))
                    ])),
          ),
        ],
      ),
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

class NumberContainer extends StatelessWidget {
  const NumberContainer({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "23",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Icon(
                Icons.people,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
      height: 120,
      width: 200,
    );
  }
}
