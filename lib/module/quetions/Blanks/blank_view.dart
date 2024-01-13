import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/module/quetions/Blanks/blanks_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BlankView extends StatelessWidget {
  BlankView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  var controller = Get.isRegistered<BlankController>()
      ? Get.find<BlankController>()
      : Get.put(BlankController());
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
                // const Text(
                //   'Active Blanks',
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.green,
                //       fontWeight: FontWeight.w700),
                // ),
                const Expanded(child: SizedBox()),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.clearForm();
                      // _showExcelInputDialog(
                      //     context); // Call the function to show input dialog
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Excel')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.clearForm();
                      Get.dialog(addBlanks(
                        controller: controller,
                        id: 0,
                        formKey: formKey,
                      ));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Blanks')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      // controller.downloadExcel(
                      //     context,
                      //     controller.blanksModel ?? UsersModel(),
                      //     'active_teacherlist');
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Data')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.fetchData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh')),
              ],
            ),
            SizedBox(height: Styles.defaultPadding * 2),
            Obx(
              () => !controller.isLoading.value
                  ? controller.questionModel!.questions!.isNotEmpty
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
                                              controller.makeDeactive(controller
                                                      .questionModel
                                                      ?.questions?[rowIndex]
                                                      .id ??
                                                  0);
                                            },
                                            child: Container(
                                                color: Colors.red,
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                alignment: Alignment.centerLeft,
                                                child: const Text('Deactivate',
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
                                                          .questionModel
                                                          ?.questions?[rowIndex]
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
                                      source: controller.blankDataSource,
                                      columnWidthMode: ColumnWidthMode.fill,
                                      columns: <GridColumn>[
                                        GridColumn(
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            columnName: 'ID',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'ID',
                                                ))),
                                        GridColumn(
                                            columnName: 'Board',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Board'))),
                                        GridColumn(
                                            columnName: 'Question',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Question',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Standard',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Standard'))),
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
                                                                .questionModel
                                                                ?.questions
                                                                ?.length
                                                                .toDouble() ??
                                                            0) /
                                                        10)
                                                    .ceil()
                                                    .toDouble(),
                                                direction: Axis.horizontal,
                                                onPageNavigationStart:
                                                    (int pageIndex) {},
                                                delegate:
                                                    controller.blankDataSource,
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

class addBlanks extends StatelessWidget {
  const addBlanks(
      {Key? key,
      required this.controller,
      required this.id,
      required this.formKey})
      : super(key: key);
  final int id;
  final BlankController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Center(
        child: Text('${id == 0 ? 'Add' : 'Edit'} Blank'),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Styles.defaultPadding),
                  TextFormField(
                    maxLines: 5,
                    controller: controller.quetionText,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your question';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  TextFormField(
                    controller: controller.answerText,
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your answer';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  TextFormField(
                    maxLines: 5,
                    controller: controller.solutionText,
                    decoration: const InputDecoration(
                      labelText: 'Solution',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your solution';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  const Text(
                    ' Choose Board:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonFormField<Boards>(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a board';
                              }
                              return null;
                            },
                            hint: const Text('Select a board'),
                            value: controller.selectedBoard.value,
                            onChanged: (Boards? newValue) {
                              controller.selectedBoard.value = newValue;
                            },
                            items: controller.boardModel?.boards?.map((board) {
                                  return DropdownMenuItem<Boards>(
                                    value: board,
                                    child: Text(board.name ?? ''),
                                  );
                                }).toList() ??
                                [],
                          ),
                        )),
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  const Text(
                    ' Choose Standard:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(() => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a standard';
                              }
                              return null;
                            },
                            value: controller.selectedStandard.value,
                            onChanged: (String? newStandard) {
                              if (newStandard != null) {
                                controller.selectedStandard.value = newStandard;
                              }
                            },
                            items: controller.standardLevels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
                  SizedBox(height: Styles.defaultPadding),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  controller.addBlank();

                  Navigator.of(context).pop();
                }
              },
              child: Text('${id == 0 ? 'Add' : 'Edit'} Blank'),
            ),
          ],
        ),
      ],
    );
  }
}
