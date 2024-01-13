import 'dart:io';

import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/module/teacher/teacher_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ActiveTeacherView extends StatelessWidget {
  ActiveTeacherView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final excelKey = GlobalKey<FormState>();
  var controller = Get.isRegistered<TeacherController>()
      ? Get.find<TeacherController>()
      : Get.put(TeacherController());
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
                //   'Active Teacher',
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.green,
                //       fontWeight: FontWeight.w700),
                // ),
                const Expanded(child: SizedBox()),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.clearForm();
                      _showExcelInputDialog(
                          context); // Call the function to show input dialog
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Excel')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.clearForm();
                      Get.dialog(addTeacher(
                        controller: controller,
                        id: 0,
                        formKey: formKey,
                      ));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Teacher')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.downloadExcel(
                          context,
                          controller.activeTeacher ?? UsersModel(),
                          'active_teacherlist');
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
                  ? controller.activeTeacher!.users!.isNotEmpty
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
                                                      .activeTeacher
                                                      ?.users?[rowIndex]
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
                                                          .activeTeacher
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
                                      source: controller.activeDataSource,
                                      columnWidthMode: ColumnWidthMode.fill,
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
                                                                .activeTeacher
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

  Future<void> _showExcelInputDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Excel Sheet '),
          content: Obx(
            () => Form(
              key: excelKey,
              child: TextFormField(
                readOnly: true,
                onTap: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx'],
                    );

                    if (result != null) {
                      String? filePath = result.files.single.path;
                      controller.file.value = filePath!;
                      print("File path: ${controller.file.value}");
                    } else {}
                  } catch (e) {
                    print("Error picking file: $e");
                  }
                },
                validator: (value) {
                  if (value == '' || value == 'No file selected') {
                    return 'Please choose a excel';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.upload),
                ),
                controller: TextEditingController(
                  text: controller.file.value != ''
                      ? controller.file.value
                      : 'No file selected',
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Obx(
              () => !controller.isAdding.value
                  ? TextButton(
                      onPressed: () async {
                        controller.isExcelValid.value = true;
                        if (excelKey.currentState!.validate()) {
                          controller.processExcelData(
                              File(
                                controller.file.value,
                              ),
                              context);
                        }
                      },
                      child: const Text('Submit'),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator()),
                    ),
            )
          ],
        );
      },
    );
  }
}

class addTeacher extends StatelessWidget {
  const addTeacher(
      {Key? key,
      required this.controller,
      required this.id,
      required this.formKey})
      : super(key: key);
  final int id;
  final TeacherController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Center(
        child: Text('${id == 0 ? 'Add' : 'Edit'} Teacher'),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 300,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Styles.defaultPadding),
                  TextFormField(
                    controller: controller.nameText,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.numberText,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+91 ',
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10, // +91 XXXXXXXXXX = 13 characters
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.schoolText,
                    decoration: const InputDecoration(
                      labelText: 'School',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your school';
                      }
                      return null;
                    },
                  ),
                  const Text(
                    ' Choose Subject:',
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
                          child: DropdownButtonFormField<Subjects>(
                            hint: const Text('Select a Subject'),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a subject';
                              }
                              return null;
                            },
                            value: controller.selectedSubject.value,
                            onChanged: (Subjects? newValue) {
                              controller.selectedSubject.value = newValue;
                            },
                            items:
                                controller.subjectModel?.subjects?.map((board) {
                                      return DropdownMenuItem<Subjects>(
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
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordText,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                            print(controller.isPasswordVisible.value);
                          },
                        ),
                      ),
                    ),
                  )
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
                  controller.addTeacher();
                  controller.fetchData();
                  Navigator.of(context).pop();
                }
              },
              child: Text('${id == 0 ? 'Add' : 'Edit'} Teacher'),
            ),
          ],
        ),
      ],
    );
  } // Function to show dialog for entering Excel sheet details
}
