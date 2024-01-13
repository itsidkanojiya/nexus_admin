import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/question_model.dart';
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/quetion_repository.dart';
import 'package:lexus_admin/repository/teacher_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TrueFalseController extends GetxController {
  @override
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  var file = ''.obs;
  RxBool isExcelValid = true.obs;
  QuestionModel? questionModel;
  var selectedBoard = Rx<Boards?>(null);
  BoardModel? boardModel;
  var quetionText = TextEditingController();
  var solutionText = TextEditingController();

  late BlankDataSource truefalseDataSource;

  var selectedStandard = '1'.obs;
  var selectedTrueFalse = 'True'.obs;
  RxBool isPasswordVisible = false.obs;

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
  final List<String> truefalse = [
    'True',
    'False',
  ];

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    boardModel = await BookRepository().getBoard();
    questionModel = await QuestionRepository().getTrueFalse();
    truefalseDataSource =
        BlankDataSource(blankData: questionModel?.questions ?? []);
    isLoading(false);
  }

  Future<void> processExcelData(File file, BuildContext context) async {
    isAdding.value = true;
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);

    var table = excel
        .tables[excel.tables.keys.first]; // Assuming 'Sheet1' is the sheet name

    for (var row in table!.rows) {
      var name = row[0]; // Assuming name is in the first column
      var number = row[1]; // Assuming number is in the second column
      var subject = row[2]; // Assuming subject is in the third column
      var std = row[3]; // Assuming std is in the fourth column
      var school = row[4]; // Assuming school is in the fifth column
      var password = row[5]; // Assuming password is in the sixth column
      // Create a map for each teacher's details
      var map = {
        "name": name?.value.toString(),
        "number":
            number != null ? int.tryParse(number.value.toString()) ?? 0 : 0,
        "subject": subject?.value.toString(),
        "std": std != null ? int.tryParse(std.value.toString()) ?? 0 : 0,
        "school": school?.value.toString(),
        "password": password?.value.toString(),
      };
      print(map);
      var result = await TeacherRepository().addTeacher(map);
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
          message: '${table.maxRows} teachers have been successfully added!',
          backgroundColor: Colors.green);
      fetchData();
      Navigator.of(context).pop();
    }
  }

  Future<void> downloadExcel(
      BuildContext context, UsersModel userlist, String name) async {
    List<List<TextCellValue>> excelData = [
      [
        const TextCellValue('ID'),
        const TextCellValue('Name'),
        const TextCellValue('Number'),
        const TextCellValue('Standard'),
        const TextCellValue('School')
      ]
    ];

    for (Users user in userlist.users ?? []) {
      excelData.add([
        TextCellValue(user.id.toString()),
        TextCellValue(user.name.toString()),
        TextCellValue(user.number.toString()),
        TextCellValue(user.std.toString()),
        TextCellValue(user.school.toString()),
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
    FileSaveHelper.saveAndLaunchFile(bytes, 'users.xlsx');
    Get.rawSnackbar(
        message: 'file is stored in $excelPath', backgroundColor: Colors.green);
  }

  void makeActive(int id) async {
    isLoading(true);
    await TeacherRepository().makActive(id);
    isLoading(false);
    fetchData();
  }

  void makeDeactive(int id) async {
    isLoading(true);
    await TeacherRepository().makDeactive(id);
    isLoading(false);
    fetchData();
  }

  void deleteTeacher(int id) async {
    isLoading(true);
    await TeacherRepository().deleteTeacher(id);
    isLoading(false);
    fetchData();
  }

  void manageTandF() async {
    isAdding(true);
    var map = {
      'bid': selectedBoard.value?.id,
      'std': selectedStandard.value,
      'question': quetionText.text,
      'answer': selectedTrueFalse.value,
      'solution': solutionText.text
    };
    print(map);
    var result = await QuestionRepository().addTrueFalse(map);
    if (result == true) {
      Get.rawSnackbar(
          message: 'True and False Added Sucessfully!',
          backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'True and False Added failed!',
          backgroundColor: Colors.redAccent);
    }
    fetchData();
    isAdding(false);
  }

  void clearForm() {
    quetionText.text = '';
    solutionText.text = '';
    selectedTrueFalse = 'True'.obs;
    selectedStandard = '1'.obs;
    selectedBoard = Rx<Boards?>(null);
    file.value = '';
    isAdding(false);
  }
}

class BlankDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  BlankDataSource({required List<Questions> blankData}) {
    _mcqData = blankData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<int>(columnName: 'Board', value: e.bid),
              DataGridCell<String>(columnName: 'Question', value: e.question),
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
