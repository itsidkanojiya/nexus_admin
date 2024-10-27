import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/question_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/quetion_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OneTwoController extends GetxController {
  @override
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  var selectedSubject = Rx<Subjects?>(null);
  SubjectModel? subjectModel;
  var file = ''.obs;
  RxBool isExcelValid = true.obs;
  QuestionModel? questionModel;
  late OneTwoDataSource oneTwoDataSource;
  var selectedChapter = '1'.obs;
  var selectedStandard = '1'.obs;
  BoardModel? boardModel;
  var selectedBoard = Rx<Boards?>(null);
  var quetionText = TextEditingController();
  var answerText = TextEditingController();
  var isRowSelected = false.obs;
  var selectedRow = 0.obs;
  var isDeleteButtonVisible = false.obs;
  List<int> firstElements = [];
  final DataGridController dataGridController = DataGridController();
  void setSelectedRow(dynamic row) {
    selectedRow.value = row;
    isRowSelected.value = true;
  }

  void clearSelectedRow() {
    selectedRow.value = 0;
    firstElements = [];
    isRowSelected.value = false;
  }

  void updateDeleteButtonVisibility(bool isVisible) {
    isDeleteButtonVisible.value = isVisible;
  }

  final List<String> standardLevels =
      List.generate(12, (index) => (index + 1).toString());
  final List<String> chapterNo =
      List.generate(50, (index) => (index + 1).toString());

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    boardModel = await BookRepository().getBoard();
    questionModel = await QuestionRepository().getOneTwo();
    oneTwoDataSource =
        OneTwoDataSource(mcqData: questionModel?.questions ?? []);
    subjectModel = await BookRepository().getSubject();
    isLoading(false);
  }

  Future<void> processExcelData(File file, BuildContext context) async {
    isAdding.value = true;
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);

    var table = excel
        .tables[excel.tables.keys.first]; // Assuming 'Sheet1' is the sheet name

    for (var row in table!.rows) {
      var board = row[0]; // Assuming name is in the first column
      var std = row[1]; // Assuming number is in the second column
      var question = row[2]; // Assuming subject is in the third column
      var answer = row[3]; // Assuming std is in the fourth column
      var solution = row[4]; // Assuming school is in the fifth column
      var subject = row[5]; // Assuming school is in the fifth column
      var chapter = row[6]; // Assuming school is in the fifth column

      var map = {
        'board': board != null ? int.tryParse(board.value.toString()) ?? 0 : 0,
        'std': std != null ? int.tryParse(std.value.toString()) ?? 0 : 0,
        'question': question?.value.toString(),
        'solution': solution?.value.toString(),
        'answer': answer?.value.toString(),
        'chapter':
            chapter != null ? int.tryParse(chapter.value.toString()) ?? 0 : 0,
        'subject':
            subject != null ? int.tryParse(subject.value.toString()) ?? 0 : 0,
      };
      print(map);
      var result = await QuestionRepository().addOneTwo(map);
      if (result == false) {
        Get.rawSnackbar(
            message: 'error in excel row ${row[0]!.rowIndex}',
            backgroundColor: Colors.redAccent);
        isAdding.value = false;
        isExcelValid.value = false;
        Navigator.of(context).pop();
        break;
      }
    }
    if (isExcelValid.value == true) {
      isAdding.value = false;
      Get.rawSnackbar(
          message: '${table.maxRows} questions have been successfully added!',
          backgroundColor: Colors.green);
      fetchData();
      Navigator.of(context).pop();
    }
  }

  Future<void> downloadExcel(
      BuildContext context, QuestionModel questions, String name) async {
    List<List<TextCellValue>> excelData = [
      [
        const TextCellValue('ID'),
        const TextCellValue('Board'),
        const TextCellValue('Standard '),
        const TextCellValue('Chapter '),
        const TextCellValue('Question'),
        const TextCellValue('Answer'),
        const TextCellValue('Solution')
      ]
    ];

    for (Questions user in questions.questions ?? []) {
      excelData.add([
        TextCellValue(user.id.toString()),
        TextCellValue(user.board.toString()),
        TextCellValue(user.std.toString()),
        TextCellValue(user.chapter.toString()),
        TextCellValue(user.question.toString()),
        TextCellValue(user.answer.toString()),
        TextCellValue(user.solution.toString()),
      ]);
    }

    // Create Excel file
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    for (var row in excelData) {
      sheetObject.appendRow(List<CellValue?>.from(row));
    }

    // Save Excel file locally
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String excelPath = '$appDocPath/$name.xlsx';

    var excelFile = File(excelPath);
    excelFile.writeAsBytesSync(excel.encode()!);

    // Trigger file download
    final bytes = File(excelPath).readAsBytesSync();
    FileSaveHelper.saveAndLaunchFile(bytes, '$name.xlsx');
    Get.rawSnackbar(
        message: 'file is stored in $excelPath', backgroundColor: Colors.green);
  }

  void MultideleteMcq(List<int> ids) async {
    isLoading(true);

    bool success = false; // Initialize success to false
    for (int id in ids) {
      success = await QuestionRepository().deleteOneTwo(id);
      // Note: this will override success on each iteration
    }
    isLoading(false);

    if (success) {
      // Check success after the loop
      Get.rawSnackbar(
          message: 'Deleted ${ids.length} question(s) successfully!',
          backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'No questions deleted', backgroundColor: Colors.red);
    }
    firstElements = [];
    fetchData();
  }

  void deleteOneTwo(int id) async {
    isLoading(true);
    await QuestionRepository().deleteOneTwo(id);
    isLoading(false);
    fetchData();
  }

  void addOneTwo() async {
    isAdding(true);
    var map = {
      'board': selectedBoard.value?.id,
      'subject': selectedSubject.value?.id,
      'std': selectedStandard.value,
      'chapter': selectedChapter.value,
      'question': quetionText.text,
      'answer': answerText.text,
    };
    print(map);
    var result = await QuestionRepository().addOneTwo(map);
    if (result == true) {
      Get.rawSnackbar(
          message: 'One Two Line Question Added Sucessfully!',
          backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'One Two Line Question Added failed!',
          backgroundColor: Colors.redAccent);
    }
    fetchData();
    isAdding(false);
  }

  void clearForm() {
    quetionText.text = '';
    selectedSubject = Rx<Subjects?>(null);
    answerText.text = '';
    selectedStandard = '1'.obs;
    selectedBoard = Rx<Boards?>(null);
    file.value = '';
    isAdding(false);
  }
}

class OneTwoDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  OneTwoDataSource({required List<Questions> mcqData}) {
    _mcqData = mcqData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'Question', value: e.question),
              DataGridCell<String>(columnName: 'Subject', value: e.subject),
              DataGridCell<String>(columnName: 'Board', value: e.board),
              DataGridCell<int>(columnName: 'Standard', value: e.std),
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

class FileSaveHelper {
  static void saveAndLaunchFile(Uint8List bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes);
  }
}
