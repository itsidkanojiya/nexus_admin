import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/teacher_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TeacherController extends GetxController {
  @override
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  var file = ''.obs;
  RxBool isExcelValid = true.obs;
  UsersModel? activeTeacher;
  UsersModel? pendingTeacher;
  late PendingDataSource pendingDataSource;
  late PendingDataSource activeDataSource;
  var nameText = TextEditingController();
  var numberText = TextEditingController();
  var schoolText = TextEditingController();
  var passwordText = TextEditingController();
  var selectedStandard = '1'.obs;
  RxBool isPasswordVisible = false.obs;

  SubjectModel? subjectModel;
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
  var selectedSubject = Rx<Subjects?>(null);
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    activeTeacher = await TeacherRepository().getActivateTeacher();
    pendingTeacher = await TeacherRepository().getPendingTeacher();
    subjectModel = await BookRepository().getSubject();
    fillTheData();
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
        const TextCellValue('Subject'),
        const TextCellValue('School'),
        const TextCellValue('Email'),
        const TextCellValue('Verified')
      ]
    ];

    for (Users user in userlist.users ?? []) {
      excelData.add([
        TextCellValue(user.id.toString()),
        TextCellValue(user.name.toString()),
        TextCellValue(user.number.toString()),
        TextCellValue(user.subject.toString()),
        TextCellValue(user.school.toString()),
        TextCellValue(user.email.toString()),
        TextCellValue(
            user.verified.toString() == 1 ? 'Verified' : 'Unverified'),
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

  void fillTheData() {
    pendingDataSource =
        PendingDataSource(employeeData: pendingTeacher?.users ?? []);
    activeDataSource =
        PendingDataSource(employeeData: activeTeacher?.users ?? []);
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

  void addTeacher() async {
    isAdding(true);
    var map = {
      "name": nameText.text,
      "number": numberText.text,
      "subject": selectedSubject.value!.name.toString(),
      "std": selectedStandard.value,
      "school": schoolText.text,
      "password": passwordText.text,
    };
    print(map);
    var result = await TeacherRepository().addTeacher(map);
    if (result == true) {
      Get.rawSnackbar(
          message: 'Teacher Added Sucessfully!', backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          message: 'Teacher Added failed!', backgroundColor: Colors.redAccent);
    }
    isAdding(false);
  }

  void clearForm() {
    nameText.text = '';
    numberText.text = '';
    selectedStandard.value = '';
    schoolText.text = '';
    passwordText.text = '';
    selectedStandard = '1'.obs;
    selectedSubject = Rx<Subjects?>(null);
    file.value = '';
    isAdding(false);
  }
}

class PendingDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PendingDataSource({required List<Users> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'number', value: e.number),
              DataGridCell<String>(columnName: 'school', value: e.school),
              DataGridCell<String>(columnName: 'subject', value: e.subject),
              DataGridCell<String>(columnName: 'email', value: e.email),
              DataGridCell<String>(
                  columnName: 'verified', value: e.verified.toString()),
              // DataGridCell<String>(columnName: 'salary', value: e.subject),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding:
            (e.columnName == 'verified') ? null : const EdgeInsets.all(8.0),
        child: (e.columnName == 'verified')
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: e.value == "1" ? Colors.green : Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(e.value == "1" ? 'Verified' : "Unverified"),
                ),
              )
            : Text(e.value.toString()),
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
