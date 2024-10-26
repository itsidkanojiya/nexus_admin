import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/layout/app_layout.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/module/solutions/solution_controller.dart';
import 'package:lexus_admin/styles/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SolutionView extends StatelessWidget {
  SolutionView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  var controller = Get.isRegistered<SolutionController>()
      ? Get.find<SolutionController>()
      : Get.put(SolutionController());

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
                //   'Active True or False',
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.green,
                //       fontWeight: FontWeight.w700),
                // ),
                const Expanded(child: SizedBox()),

                SizedBox(
                  width: Styles.defaultPadding,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.clearForm();
                      Get.dialog(addSolution(
                        controller: controller,
                        id: 0,
                        formKey: formKey,
                      ));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Solution')),

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
                  ? controller.solutionModel!.solutions!.isNotEmpty
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
                                      controller: controller.dataGridController,
                                      showCheckboxColumn: true,
                                      selectionMode: SelectionMode.multiple,
                                      rowsPerPage: 10,
                                      allowFiltering: true,
                                      allowSorting: true,
                                      swipeMaxOffset: 120,
                                      allowSwiping: true,
                                      endSwipeActionsBuilder:
                                          (BuildContext context,
                                              DataGridRow row, int rowIndex) {
                                        return GestureDetector(
                                            // onTap: () async {},
                                            // child: Container(
                                            //     color: Colors.red,
                                            //     padding: const EdgeInsets.only(
                                            //         left: 30.0),
                                            //     alignment: Alignment.centerLeft,
                                            //     child: const Text('Deactivate',
                                            //         style: TextStyle(
                                            //             color: Colors.white)))
                                            );
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
                                              controller.deleteSolution(
                                                  controller
                                                          .solutionModel
                                                          ?.solutions?[rowIndex]
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
                                      source: controller.solutionDataSource,
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
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            columnName: 'Standard',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Standard',
                                                ))),
                                        GridColumn(
                                            columnName: 'Board',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text('Board'))),
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
                                            columnName: 'Chapter Name',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                    'Chapter Name'))),
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
                                                                .solutionModel
                                                                ?.solutions
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
                                                    .solutionDataSource,
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

class addSolution extends StatelessWidget {
  const addSolution(
      {Key? key,
      required this.controller,
      required this.id,
      required this.formKey})
      : super(key: key);
  final int id;
  final SolutionController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Center(
        child: Text('${id == 0 ? 'Add' : 'Edit'} Solution'),
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
                  const Text(
                    ' Chapter No:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: controller.cnumberText,
                    // decoration: const InputDecoration(
                    //   labelText: '0',
                    // ),
                    validator: (value) {
                      if (value!.isEmpty || value.isAlphabetOnly) {
                        return 'Please enter your chapter number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  const Text(
                    ' Chapter Name:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: controller.cnameText,
                    // decoration: const InputDecoration(
                    //   labelText: 'Name',
                    // ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your chapter number';
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
                    ' Choose Book:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => TextFormField(
                      readOnly: true,
                      onTap: () async {
                        try {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          if (result != null) {
                            String? filePath = result.files.single.path;
                            controller.pdf_link.value = filePath ?? '';
                            print("File path: ${controller.pdf_link.value}");
                          } else {}
                        } catch (e) {
                          print("Error picking file: $e");
                        }
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.upload),
                      ),
                      validator: (value) {
                        if (value == '' || value == 'No file selected') {
                          return 'Please choose a solution';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: controller.pdf_link.value != ''
                            ? controller.pdf_link.value
                            : 'No file selected',
                      ),
                    ),
                  ),
                  SizedBox(height: Styles.defaultPadding),
                  const Text(
                    ' Choose Cover Image:',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => TextFormField(
                      readOnly: true,
                      onTap: () async {
                        try {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            //  allowedExtensions: ['pdf'],
                          );

                          if (result != null) {
                            String? filePath = result.files.single.path;
                            controller.coverImage_link.value = filePath ?? '';
                            print(
                                "File path: ${controller.coverImage_link.value}");
                          } else {}
                        } catch (e) {
                          print("Error picking file: $e");
                        }
                      },
                      validator: (value) {
                        if (value == '' || value == 'No file selected') {
                          return 'Please choose a cover image';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.upload),
                      ),
                      controller: TextEditingController(
                        text: controller.coverImage_link.value != ''
                            ? controller.coverImage_link.value
                            : 'No file selected',
                      ),
                    ),
                  ),
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
                  controller.addSolution();
                  controller.fetchData();
                  Navigator.of(context).pop();
                }
              },
              child: Text('${id == 0 ? 'Add' : 'Edit'} Solution'),
            ),
          ],
        ),
      ],
    );
  }
}

class BookWidget extends StatelessWidget {
  int index;
  BookWidget({
    Key? key,
    required this.index,
    required this.controller,
  }) : super(key: key);

  final SolutionController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            controller.solutionModel?.solutions?[index].coverLink ?? '',
            height: 200,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.solutionModel?.solutions?[index].name ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {
                    controller.deleteSolution(
                        controller.solutionModel?.solutions?[index].id ?? 0);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
