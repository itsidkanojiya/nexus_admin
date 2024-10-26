// solution_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/solution_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/solution_repository.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SolutionController extends GetxController {
  var selectedBoard = Rx<Boards?>(null);
  var selectedSubject = Rx<Subjects?>(null);
  SubjectModel? subjectModel;
  var authorName = ''.obs;
  var pdf_link = ''.obs;
  var coverImage_link = ''.obs;
  var selectedStandard = '1'.obs;
  var cnameText = TextEditingController();
  var cnumberText = TextEditingController();
  var subjectText = TextEditingController();
  var isValid = false.obs;
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  BoardModel? boardModel;
  SolutionModel? solutionModel;
  var isRowSelected = false.obs;
  var selectedRow = 0.obs;
  var isDeleteButtonVisible = false.obs;
  final List<String> standardLevels = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  List<int> firstElements = [];
  void setSelectedRow(dynamic row) {
    selectedRow.value = row;
    isRowSelected.value = true;
  }

  late BookDataSource solutionDataSource;
  final DataGridController dataGridController = DataGridController();

  void updateDeleteButtonVisibility(bool isVisible) {
    isDeleteButtonVisible.value = isVisible;
  }

  void clearSelectedRow() {
    selectedRow.value = 0;
    firstElements = [];
    isRowSelected.value = false;
  }

  @override
  void onInit() {
    fetchData();

    super.onInit();
  }

  void addSubject() async {
    isAdding(true);
    var map = {'name': subjectText.text.toString()};
    await BookRepository().addSubject(map);

    isAdding(false);
  }

  void deleteSolution(int id) async {
    isLoading(true);
    var success = await SolutionRepository().deleteSolution(id);
    if (success == true) {
      Get.rawSnackbar(
          message: 'Deleted Sucessfully!', backgroundColor: Colors.green);
    }
    isLoading(false);
    fetchData();
  }

  void addSolution() async {
    isAdding(true);
    var map = {
      'subject': selectedSubject.value!.id,
      'name': selectedSubject.value!.name.toString(),
      'std': selectedStandard.value,
      'board': selectedBoard.value!.id,
      'chapter_no': cnumberText.text,
      'chapter_name': cnameText.text,
    };
    await SolutionRepository()
        .addSolution(map, coverImage_link.value, pdf_link.value);

    isAdding(false);
  }

  void clearForm() {
    selectedBoard = Rx<Boards?>(null);
    selectedStandard = '1'.obs;
    pdf_link = ''.obs;
    cnameText.clear();
    cnumberText.clear();
    coverImage_link = ''.obs;
    selectedSubject = Rx<Subjects?>(null);
    isValid.value = false;
  }

  void MultideleteMcq(List<int> ids) async {
    isLoading(true);

    bool success = false; // Initialize success to false
    for (int id in ids) {
      success = await SolutionRepository().deleteSolution(id);
      // Note: this will override success on each iteration
    }
    isLoading(false);

    if (success) {
      // Check success after the loop
      Get.rawSnackbar(
          message: 'Deleted ${ids.length} Book(s) successfully!',
          backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'No Solution deleted', backgroundColor: Colors.red);
    }
    firstElements = [];
    fetchData();
  }

  void fetchData() async {
    isLoading(true);
    solutionModel = await SolutionRepository().getSolutions();
    boardModel = await BookRepository().getBoard();
    subjectModel = await BookRepository().getSubject();
    solutionDataSource =
        BookDataSource(solutionData: solutionModel?.solutions ?? []);
    isLoading(false);
  }
}

class BookDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  BookDataSource({required List<Solutions> solutionData}) {
    _mcqData = solutionData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'ID', value: e.id),
              DataGridCell<int>(columnName: 'Standard', value: e.std),

              DataGridCell<String>(columnName: 'Board', value: e.boardName),
              DataGridCell<String>(columnName: 'Subject', value: e.subjectName),

              DataGridCell<String>(
                  columnName: 'Chapter Name', value: e.chapterName),

              // DataGridCell<String>(columnName: 'salary', value: e.subject),
            ]))
        .toList();
  }

  List<DataGridRow> _mcqData = [];

  @override
  List<DataGridRow> get rows => _mcqData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
