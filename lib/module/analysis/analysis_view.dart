import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:fintech_dashboard_clone/layout/app_layout.dart';
import 'package:fintech_dashboard_clone/module/analysis/analysis_controller.dart';
import 'package:fintech_dashboard_clone/module/auth/auth_service.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisView extends StatelessWidget {
  AnalysisView({Key? key}) : super(key: key);

  var controller = Get.isRegistered<AnalysisController>()
      ? Get.find<AnalysisController>()
      : Get.put(AnalysisController());

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        content: MediaQuery.of(context).size.width >= 670
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Row(
                        children: [
                          const MenuWidget(
                            index: 0,
                            color: Colors.white,
                            image: "assets/teacher.png",
                            text: "Teacher",
                          ),
                          const SizedBox(width: 20),
                          MenuWidget(
                            index: 1,
                            color: Theme.of(context).colorScheme.primary,
                            image: "assets/graduated.png",
                            text: "Student",
                          ),
                          const SizedBox(width: 20),
                          const MenuWidget(
                            index: 2,
                            color: Colors.white,
                            image: "assets/lightbulb.png",
                            text: "Question",
                          ),
                        ],
                      ),
                    ),
                    Obx(() => controller.isLoading.value != true
                        ? Obx(() {
                            switch (AuthService.analysisIndex.value) {
                              case 0:
                                return TeacherView();
                              case 1:
                                return Studentview();

                              case 2:
                                return Questionsview();

                              default:
                                return TeacherView();
                            }
                          })
                        : AnimatedShimmer(
                            width: Get.width,
                            height: 500,
                            borderRadius: BorderRadius.circular(20),
                          ))
                  ],
                ),
              )
            : const SizedBox());
  }
}

class TeacherView extends StatelessWidget {
  TeacherView({
    Key? key,
  }) : super(key: key);

  var controller = Get.isRegistered<AnalysisController>()
      ? Get.find<AnalysisController>()
      : Get.put(AnalysisController());
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);

    List<ChartData> teacherchartData = [
      ChartData(
          1, controller.teacherAnalysisModel?.chart!.i1?.toDouble() ?? 0.0),
      ChartData(
          2, controller.teacherAnalysisModel?.chart!.i2?.toDouble() ?? 0.0),
      ChartData(
          3, controller.teacherAnalysisModel?.chart!.i3?.toDouble() ?? 0.0),
      ChartData(
          4, controller.teacherAnalysisModel?.chart!.i4?.toDouble() ?? 0.0),
      ChartData(
          5, controller.teacherAnalysisModel?.chart!.i5?.toDouble() ?? 0.0),
      ChartData(
          6, controller.teacherAnalysisModel?.chart!.i6?.toDouble() ?? 0.0),
      ChartData(
          7, controller.teacherAnalysisModel?.chart!.i7?.toDouble() ?? 0.0),
      ChartData(
          8, controller.teacherAnalysisModel?.chart!.i8?.toDouble() ?? 0.0),
      ChartData(
          9, controller.teacherAnalysisModel?.chart!.i10?.toDouble() ?? 0.0),
      ChartData(
          10, controller.teacherAnalysisModel?.chart!.i11?.toDouble() ?? 0.0),
      ChartData(
          11, controller.teacherAnalysisModel?.chart!.i2?.toDouble() ?? 0.0),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NumberContainer(
              text: 'Active Teacher',
              value: controller.teacherAnalysisModel?.active.toString() ?? '',
            ),
            NumberContainer(
              text: 'Pending Teacher',
              value: controller.teacherAnalysisModel?.pending.toString() ?? '',
            ),
            MediaQuery.of(context).size.width >= 825
                ? NumberContainer(
                    text: 'Monthly Teacher',
                    value: controller.teacherAnalysisModel?.monthlyUsers
                            .toString() ??
                        '',
                  )
                : const SizedBox(),
            MediaQuery.of(context).size.width >= 1026
                ? NumberContainer(
                    text: 'Daily Teacher',
                    value: controller.teacherAnalysisModel?.dailyUsers
                            .toString() ??
                        '',
                  )
                : const SizedBox(),
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
                        dataSource: teacherchartData,
                        xValueMapper: (ChartData data, _) => data.x.toString(),
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            // Positioning the data label
                            labelAlignment: ChartDataLabelAlignment.top))
                  ])),
        ),
      ],
    );
  }
}

class Studentview extends StatelessWidget {
  Studentview({
    Key? key,
  }) : super(key: key);

  var controller = Get.isRegistered<AnalysisController>()
      ? Get.find<AnalysisController>()
      : Get.put(AnalysisController());

  @override
  Widget build(BuildContext context) {
    List<ChartData> studentchartData = [
      ChartData(
          1, controller.studentAnalysisModel?.chart!.i1?.toDouble() ?? 0.0),
      ChartData(
          2, controller.studentAnalysisModel?.chart!.i2?.toDouble() ?? 0.0),
      ChartData(
          3, controller.studentAnalysisModel?.chart!.i3?.toDouble() ?? 0.0),
      ChartData(
          4, controller.studentAnalysisModel?.chart!.i4?.toDouble() ?? 0.0),
      ChartData(
          5, controller.studentAnalysisModel?.chart!.i5?.toDouble() ?? 0.0),
      ChartData(
          6, controller.studentAnalysisModel?.chart!.i6?.toDouble() ?? 0.0),
      ChartData(
          7, controller.studentAnalysisModel?.chart!.i7?.toDouble() ?? 0.0),
      ChartData(
          8, controller.studentAnalysisModel?.chart!.i8?.toDouble() ?? 0.0),
      ChartData(
          9, controller.studentAnalysisModel?.chart!.i10?.toDouble() ?? 0.0),
      ChartData(
          10, controller.studentAnalysisModel?.chart!.i11?.toDouble() ?? 0.0),
      ChartData(
          11, controller.studentAnalysisModel?.chart!.i2?.toDouble() ?? 0.0),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NumberContainer(
              text: 'Total Students',
              value:
                  controller.studentAnalysisModel?.totalUser.toString() ?? '',
            ),
            NumberContainer(
              text: 'Monthly Students',
              value: controller.studentAnalysisModel?.monthlyUsers.toString() ??
                  '',
            ),
            MediaQuery.of(context).size.width >= 829
                ? NumberContainer(
                    text: 'Daily Students',
                    value: controller.studentAnalysisModel?.dailyUsers
                            .toString() ??
                        '',
                  )
                : const SizedBox(),
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
                        dataSource: studentchartData,
                        xValueMapper: (ChartData data, _) => data.x.toString(),
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            // Positioning the data label
                            labelAlignment: ChartDataLabelAlignment.top))
                  ])),
        ),
      ],
    );
  }
}

class Questionsview extends StatelessWidget {
  Questionsview({
    Key? key,
  }) : super(key: key);

  var controller = Get.isRegistered<AnalysisController>()
      ? Get.find<AnalysisController>()
      : Get.put(AnalysisController());
  @override
  Widget build(BuildContext context) {
    final List<PieChartData> piechartData = [
      PieChartData("Total Mcq",
          controller.questionAnalysisModel?.mcq?.toDouble() ?? 0.0),
      PieChartData("Total Blank",
          controller.questionAnalysisModel?.blank?.toDouble() ?? 0.0),
      PieChartData("Total One Two",
          controller.questionAnalysisModel?.onetwo?.toDouble() ?? 0.0),
      PieChartData("Total Short",
          controller.questionAnalysisModel?.short?.toDouble() ?? 0.0),
      PieChartData("Total Long",
          controller.questionAnalysisModel?.long?.toDouble() ?? 0.0),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NumberContainer(
              text: 'Total Question',
              value: controller.questionAnalysisModel?.total.toString() ?? '',
            ),
            NumberContainer(
              text: 'Total Mcq',
              value: controller.questionAnalysisModel?.mcq.toString() ?? '',
            ),
            MediaQuery.of(context).size.width >= 829
                ? NumberContainer(
                    text: 'Total Blank',
                    value: controller.questionAnalysisModel?.blank.toString() ??
                        '',
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NumberContainer(
              text: 'Total One Two',
              value: controller.questionAnalysisModel?.onetwo.toString() ?? '',
            ),
            NumberContainer(
              text: 'Total Short',
              value: controller.questionAnalysisModel?.short.toString() ?? '',
            ),
            MediaQuery.of(context).size.width >= 829
                ? NumberContainer(
                    text: 'Total Long',
                    value:
                        controller.questionAnalysisModel?.long.toString() ?? '',
                  )
                : const SizedBox(),
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
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<PieChartData, String>(
                      dataSource: piechartData,
                      explode: true,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      xValueMapper: (PieChartData data, _) => data.x,
                      yValueMapper: (PieChartData data, _) => data.y,
                      // Radius of pie
                      radius: '80%')
                ],
                legend: const Legend(isVisible: true),
              )),
        ),
      ],
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    Key? key,
    required this.text,
    required this.image,
    required this.color,
    required this.index,
  }) : super(key: key);
  final String text;
  final String image;
  final Color color;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: (() {
          AuthService.analysisIndex.value = index;
        }),
        child: Container(
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AuthService.analysisIndex.value == index
                ? const Color.fromARGB(255, 250, 118, 78)
                : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(height: 25, child: Image.asset(image)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 15,
                      color: AuthService.analysisIndex.value == index
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

class PieChartData {
  PieChartData(this.x, this.y);
  final String x;
  final double y;
}

class NumberContainer extends StatelessWidget {
  const NumberContainer({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);
  final String text;
  final String value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Icon(
                //   Icons.people,
                //   color: Colors.white,
                // ),
                Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        height: 120,
        width: 200,
      ),
    );
  }
}
