import 'dart:io';

import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/mcq_modal.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/module/quetions/Mcq/mcq_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class McqView extends StatelessWidget {
  McqView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  var controller = Get.isRegistered<McqController>()
      ? Get.find<McqController>()
      : Get.put(McqController());

  Future<void> _showExcelInputDialog(BuildContext context) async {
    final excelKey = GlobalKey<FormState>();
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
                //   'Active Mcq',
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
                      Get.dialog(addMcq(
                        controller: controller,
                        id: 0,
                        formKey: formKey,
                      ));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Mcq')),
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.downloadExcel(context,
                          controller.questionModel ?? McqModel(), 'mcqlist');
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
                SizedBox(
                  width: Styles.defaultPadding,
                ),
                Obx(() => Visibility(
                      visible: controller.isRowSelected.value,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        onPressed: () {
                          controller.MultideleteMcq(controller.firstElements);

                          // Handle delete action here
                          controller.clearSelectedRow();
                        },
                      ),
                    )),
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
                                        color: const Color(0xFFFFFFFF)),
                                    child: SfDataGrid(
                                      onSelectionChanged:
                                          (addedRows, removedRows) {
                                        List<List<dynamic>> selectedRowsData =
                                            []; //SelectedRows
                                        for (var selectedRowIndex in controller
                                            .dataGridController.selectedRows) {
                                          List<dynamic> rowData = [];
                                          var selectedRowCells =
                                              selectedRowIndex.getCells();
                                          for (var cell in selectedRowCells) {
                                            rowData.add(cell
                                                .value); // Convert cell value to string
                                          }
                                          selectedRowsData.add(rowData);
                                        }

                                        controller.firstElements
                                            .clear(); // Clear previous selected elements

                                        for (var rowData in selectedRowsData) {
                                          if (rowData.isNotEmpty) {
                                            controller.firstElements
                                                .add(rowData[0]);
                                          }
                                        }

                                        if (controller
                                            .firstElements.isNotEmpty) {
                                          controller.setSelectedRow(
                                              controller.firstElements.first);
                                        } else {
                                          controller.clearSelectedRow();
                                        }
                                        // Update visibility of delete button
                                        controller.updateDeleteButtonVisibility(
                                            controller
                                                .firstElements.isNotEmpty);
                                      },
                                      showCheckboxColumn: true,
                                      controller: controller.dataGridController,
                                      selectionMode: SelectionMode.multiple,
                                      rowsPerPage: 10,
                                      allowFiltering: true,
                                      allowSorting: true,
                                      swipeMaxOffset: 120,
                                      allowSwiping: true,
                                      endSwipeActionsBuilder:
                                          (BuildContext context,
                                              DataGridRow row, int rowIndex) {
                                        return GestureDetector();
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
                                              controller.deleteMcq(controller
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
                                      source: controller.mcqDataSource,
                                      columnWidthMode:
                                          ColumnWidthMode.lastColumnFill,
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
                                            columnName: 'Option 1',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Option 1',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Option 2',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Option 2',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Option 3',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Option 3',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Option 4',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Option 4',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Subject',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Subject',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            columnName: 'Board',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Board'))),
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
                                                    controller.mcqDataSource,
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

class addMcq extends StatelessWidget {
  const addMcq(
      {Key? key,
      required this.controller,
      required this.id,
      required this.formKey})
      : super(key: key);
  final int id;
  final McqController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Center(
        child: Text('${id == 0 ? 'Add' : 'Edit'} Mcq'),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.option1Text,
                    decoration: const InputDecoration(
                      labelText: 'Option 1',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.option2Text,
                    decoration: const InputDecoration(
                      labelText: 'Option 2',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.option3Text,
                    decoration: const InputDecoration(
                      labelText: 'Option 3',
                    ),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please enter your option';
                    //   }
                    //   return null;
                    //  },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.option4Text,
                    decoration: const InputDecoration(
                      labelText: 'Option 4',
                    ),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please enter your option';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  const Text(
                    ' Choose Answer:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(() => Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonFormField<String>(
                                value: controller.optionValue.value,
                                onChanged: (String? newStandard) {
                                  if (newStandard != null) {
                                    if (newStandard == 'Select answer') {
                                      controller.optionValue.value =
                                          newStandard;
                                      controller.answerText.value =
                                          ''; // Set answerText to null for "Other" option
                                    } else {
                                      controller.optionValue.value =
                                          newStandard;
                                      controller.setAnswer();
                                    }
                                  }
                                },
                                items: [
                                  'Select answer',
                                  ...controller.option
                                ] // Add 'Other' option to the list
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: Styles.defaultPadding),
                        ],
                      )),
                  TextFormField(
                    maxLines: 5,
                    controller: controller.solutionText,
                    decoration: const InputDecoration(
                      labelText: 'Solution',
                    ),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please enter your solution';
                    //   }
                    //   return null;
                    // },
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
                  const Text(
                    ' Choose Chapter:',
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
                            value: controller.selectedChapter.value,
                            onChanged: (String? newStandard) {
                              if (newStandard != null) {
                                controller.selectedChapter.value = newStandard;
                              }
                            },
                            items: controller.chapterNo
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
                  controller.addMcq();
                  Navigator.of(context).pop();
                }
              },
              child: Text('${id == 0 ? 'Add' : 'Edit'} Mcq'),
            ),
          ],
        ),
      ],
    );
  }
}
