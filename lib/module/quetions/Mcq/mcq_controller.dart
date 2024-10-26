import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/mcq_modal.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/quetion_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class McqController extends GetxController {
  @override
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  var file = ''.obs;
  var selectedBoard = Rx<Boards?>(null);
  RxBool isExcelValid = true.obs;
  McqModel? questionModel;
  final DataGridController dataGridController = DataGridController();
  late McqDataSource mcqDataSource;
  BoardModel? boardModel;
  var answerText = ''.obs;
  var quetionText = TextEditingController();
  var option1Text = TextEditingController();
  var option2Text = TextEditingController();
  var option3Text = TextEditingController();
  var option4Text = TextEditingController();
  var solutionText = TextEditingController();
  var selectedChapter = '1'.obs;
  var selectedStandard = '1'.obs;
  var optionValue = 'Option 1'.obs;
  RxBool isPasswordVisible = false.obs;
  var selectedSubject = Rx<Subjects?>(null);
  SubjectModel? subjectModel;
  var isRowSelected = false.obs;
  var selectedRow = 0.obs;
  var isDeleteButtonVisible = false.obs;
  List<int> firstElements = [];
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
  final List<String> option = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  void setAnswer() {
    if (optionValue.value == 'Option 1') {
      answerText.value = option1Text.text;
    } else if (optionValue.value == 'Option 2') {
      answerText.value = option2Text.text;
    } else if (optionValue.value == 'Option 3') {
      answerText.value = option3Text.text;
    } else if (optionValue.value == 'Option 4') {
      answerText.value = option4Text.text;
    }
    print(answerText);
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    boardModel = await BookRepository().getBoard();
    questionModel = await QuestionRepository().getMcq();
    subjectModel = await BookRepository().getSubject();
    mcqDataSource = McqDataSource(mcqData: questionModel?.questions ?? []);
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
      var option1 = row[3]; // Assuming subject is in the third column
      var option2 = row[4]; // Assuming subject is in the third column
      var option3 = row[5]; // Assuming subject is in the third column
      var option4 = row[6]; // Assuming subject is in the third column
      var answer = row[7]; // Assuming std is in the fourth column
      var solution = row[8]; // Assuming school is in the fifth column
      var subject = row[9]; // Assuming school is in the fifth column
      var chapter = row[10]; // Assuming school is in the fifth column
      var map = {
        'board': board != null ? int.tryParse(board.value.toString()) ?? 0 : 0,
        'std': std != null ? int.tryParse(std.value.toString()) ?? 0 : 0,
        'question': question?.value.toString(),
        'options': [
          option1?.value.toString() ?? '',
          option2?.value.toString() ?? '',
          option3?.value.toString() ?? '',
          option4?.value.toString() ?? '',
        ],
        'solution': solution?.value.toString(),
        'answer': answer?.value.toString(),
        'chapter':
            chapter != null ? int.tryParse(chapter.value.toString()) ?? 0 : 0,
        'subject':
            subject != null ? int.tryParse(subject.value.toString()) ?? 0 : 0,
      };
      print(map);
      var result = await QuestionRepository().addMcq(map);
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
      BuildContext context, McqModel questions, String name) async {
    List<List<TextCellValue>> excelData = [
      [
        const TextCellValue('ID'),
        const TextCellValue('Board'),
        const TextCellValue('Standard '),
        const TextCellValue('Subject'),
        const TextCellValue('Chapter'),
        const TextCellValue('Question'),
        const TextCellValue('Answer'),
        const TextCellValue('option 1'),
        const TextCellValue('option 2'),
        const TextCellValue('option 3'),
        const TextCellValue('option 4'),
        const TextCellValue('Solution'),
      ]
    ];

    for (Questions user in questions.questions ?? []) {
      List<String?> options = user.options ??
          List.filled(4, ''); // Fill missing options with empty strings
      excelData.add([
        TextCellValue(user.id.toString()),
        TextCellValue(user.boardName.toString()),
        TextCellValue(user.std.toString()),
        TextCellValue(user.subject.toString()),
        TextCellValue(user.chapter.toString()),
        TextCellValue(user.question.toString()),
        TextCellValue(user.answer.toString()),
        TextCellValue(options.isNotEmpty ? options[0]?.toString() ?? '' : ''),
        TextCellValue(options.length > 1 ? options[1]?.toString() ?? '' : ''),
        TextCellValue(options.length > 2 ? options[2]?.toString() ?? '' : ''),
        TextCellValue(options.length > 3 ? options[3]?.toString() ?? '' : ''),
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

  void deleteMcq(int id) async {
    isLoading(true);
    bool sucess;
    sucess = await QuestionRepository().deleteMcq(id);
    isLoading(false);
    if (sucess == true) {
      Get.rawSnackbar(
          message: 'Deleted Sucessfully!', backgroundColor: Colors.green);
    }
    fetchData();
  }

  void MultideleteMcq(List<int> ids) async {
    isLoading(true);

    bool success = false; // Initialize success to false
    for (int id in ids) {
      success = await QuestionRepository().deleteMcq(id);
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

  void addMcq() async {
    isAdding(true);
    List<String> options = [
      option1Text.text,
      option2Text.text,
      option3Text.text,
      option4Text.text,
    ];
    options = options.where((option) => option.isNotEmpty).toList();
    var map = {
      'board': selectedBoard.value?.id,
      'subject': selectedSubject.value?.id,
      'std': selectedStandard.value,
      'question': quetionText.text,
      'options': options,
      'answer': answerText.value,
      'solution': solutionText.text,
      'chapter': selectedChapter.value
    };
    print(map);
    var result = await QuestionRepository().addMcq(map);
    if (result == true) {
      Get.rawSnackbar(
          message: 'Mcq Added Sucessfully!', backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'Mcq Added failed!', backgroundColor: Colors.redAccent);
    }
    fetchData();
    isAdding(false);
  }

  void clearForm() {
    quetionText.text = '';
    option1Text.text = '';
    option2Text.text = '';
    option3Text.text = '';
    option4Text.text = '';
    solutionText.text = '';
    answerText.value = '';
    selectedStandard = '1'.obs;
    selectedChapter = '1'.obs;
    selectedSubject = Rx<Subjects?>(null);
    selectedBoard = Rx<Boards?>(null);
    file.value = '';
    isAdding(false);
  }
}

class McqDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  McqDataSource({required List<Questions> mcqData}) {
    _mcqData = mcqData.map<DataGridRow>((e) {
      List<String?> options = e.options ??
          List.filled(4, ''); // Fill missing options with empty strings
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'Question', value: e.question),
        DataGridCell<String>(
            columnName: 'Option 1',
            value: options.isNotEmpty ? options[0] ?? '' : ''),
        DataGridCell<String>(
            columnName: 'Option 2',
            value: options.length > 1 ? options[1] ?? '' : ''),
        DataGridCell<String>(
            columnName: 'Option 3',
            value: options.length > 2 ? options[2] ?? '' : ''),
        DataGridCell<String>(
            columnName: 'Option 4',
            value: options.length > 3 ? options[3] ?? '' : ''),
        DataGridCell<String>(columnName: 'Subject', value: e.subject),
        DataGridCell<String>(columnName: 'Board', value: e.boardName),
        DataGridCell<int>(columnName: 'Standard', value: e.std),
      ]);
    }).toList();
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
