import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fintech_dashboard_clone/layout/app_layout.dart';
import 'package:fintech_dashboard_clone/models/board_model.dart';
import 'package:fintech_dashboard_clone/models/subject_model.dart';
import 'package:fintech_dashboard_clone/module/solutions/solution_controller.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: Column(children: [
        Row(
          children: [
            const Expanded(child: SizedBox()),
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
                label: const Text('Add Solutions')),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  controller.fetchData();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh')),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height -
              200, // Adjust the height as needed,
          child: Obx(() => !controller.isLoading.value
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // Adjust the number of columns as needed
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: controller.solutionModel?.solutions?.length,
                  itemBuilder: (context, index) {
                    return SolutionWidget(
                      index: index,
                      controller: controller,
                    );
                  },
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // Adjust the number of columns as needed
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return AnimatedShimmer(
                      height: 10,
                      width: 180,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      delayInMilliSeconds: Duration(milliseconds: index * 500),
                    );
                  },
                )),
        )
      ]),
    ));
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
                    ' Choose Solution:',
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
                            controller.pdf_link.value = filePath!;
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
                          return 'Please choose a book';
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
                            controller.coverImage_link.value = filePath!;
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

class SolutionWidget extends StatelessWidget {
  int index;
  SolutionWidget({
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
