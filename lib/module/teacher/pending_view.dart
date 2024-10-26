import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/module/teacher/teacher_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PendingTeacherView extends StatelessWidget {
  PendingTeacherView({Key? key}) : super(key: key);
  var controller = Get.isRegistered<TeacherController>()
      ? Get.find<TeacherController>()
      : Get.put(TeacherController());

  final double _dataPagerHeight = 60.0;

// final List<OrderInfo> _orders = [];

// final List<OrderInfo> _paginatedOrders = [];

// final OrderInfoDataSource _orderInfoDataSource = OrderInfoDataSource();
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                Text(
                  'Pending Verification',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.downloadExcel(
                          context,
                          controller.pendingTeacher ?? UsersModel(),
                          'pending_teacherlist');
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Data')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      print(controller.pendingTeacher!.users!.length);
                      controller.fetchData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh')),
              ],
            ),
            SizedBox(height: Styles.defaultPadding * 2),
            Obx(
              () => !controller.isLoading.value
                  ? controller.pendingTeacher!.users!.isNotEmpty
                      ? LayoutBuilder(builder: (context, constraints) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 500,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    height: 400,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.white),
                                    child: SfDataGrid(
                                      onCellTap: ((details) {}),
                                      rowsPerPage: 10,
                                      allowFiltering: true,
                                      allowSorting: true,
                                      swipeMaxOffset: 120,
                                      allowSwiping: true,
                                      endSwipeActionsBuilder:
                                          (BuildContext context,
                                              DataGridRow row, int rowIndex) {
                                        return GestureDetector(
                                            onTap: () async {
                                              controller.makeActive(controller
                                                      .pendingTeacher
                                                      ?.users?[rowIndex]
                                                      .id ??
                                                  0);
                                              controller.fetchData();
                                            },
                                            child: Container(
                                                color: Colors.green,
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                alignment: Alignment.centerLeft,
                                                child: const Text('Activate',
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      },
                                      onSwipeUpdate: (details) {
                                        return true;
                                      },
                                      onSwipeEnd: (details) async {},
                                      startSwipeActionsBuilder:
                                          (BuildContext context,
                                              DataGridRow row, int rowIndex) {
                                        return GestureDetector(
                                            onTap: () async {
                                              controller.deleteTeacher(
                                                  controller
                                                          .pendingTeacher
                                                          ?.users?[rowIndex]
                                                          .id ??
                                                      0);
                                              controller.fetchData();
                                            },
                                            child: Container(
                                                color: Colors.red,
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                alignment: Alignment.centerLeft,
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      },
                                      source: controller.pendingDataSource,
                                      columnWidthMode:
                                          ColumnWidthMode.lastColumnFill,
                                      columns: <GridColumn>[
                                        GridColumn(
                                            columnName: 'name',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Name',
                                                ))),
                                        GridColumn(
                                            columnName: 'number',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Number'))),
                                        GridColumn(
                                            columnName: 'school',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'School',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'subject',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Subject'))),
                                        GridColumn(
                                            columnName: 'email',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Email'))),
                                        GridColumn(
                                            columnName: 'verified',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Verified'))),
                                      ],
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 60,
                                            width: constraints.maxWidth - 40,
                                            child: SfDataPager(
                                                availableRowsPerPage: const [
                                                  10,
                                                  20,
                                                  30
                                                ],
                                                pageCount: ((controller
                                                                .pendingTeacher
                                                                ?.users
                                                                ?.length
                                                                .toDouble() ??
                                                            0) /
                                                        10)
                                                    .ceil()
                                                    .toDouble(),
                                                direction: Axis.horizontal,
                                                onPageNavigationStart:
                                                    (int pageIndex) {},
                                                delegate: controller
                                                    .pendingDataSource,
                                                onPageNavigationEnd:
                                                    (int pageIndex) {
                                                  //You can do your customization
                                                }))
                                      ])
                                ],
                              ),
                            ),
                          );
                        })
                      : Column(
                          children: [
                            Lottie.asset("assets/nodata.json"),
                            SizedBox(
                              height: Styles.defaultPadding,
                            ),
                            const Text('No Data Found')
                          ],
                        )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedShimmer(
                        height: 600,
                        width: Get.width,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
