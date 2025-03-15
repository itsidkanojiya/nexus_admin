import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/change_subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ChangeSubjectController extends GetxController {
  @override
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  List<ChangeSubjectModel>? changeSubjectModel;
  RxBool isExcelValid = true.obs;
  late DataSource studentDataSource;

  var selectedStandard = '1'.obs;
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

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);

    changeSubjectModel = await BookRepository().getChangeSubjectRequest();

    studentDataSource = DataSource(employeeData: changeSubjectModel ?? []);
    isLoading(false);
  }

  void approveRequest(int id) async {
    isLoading(true);
    await BookRepository().approveRequest(id);
    isLoading(false);
    fetchData();
  }

  void rejectRequest(int id) async {
    isLoading(true);
    await BookRepository().rejectRequest(id);
    isLoading(false);
    fetchData();
  }
}

class DataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  DataSource({required List<ChangeSubjectModel> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'email', value: e.email),
              DataGridCell<String>(
                  columnName: 'Current Subject', value: e.requestedSubject),
              DataGridCell<String>(
                  columnName: 'Requested Subject', value: e.subject),
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
