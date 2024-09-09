// Solution_controller.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/solution_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';
import 'package:lexus_admin/repository/solution_repository.dart';

class SolutionController extends GetxController {
  var selectedBoard = Rx<Boards?>(null);
  var selectedSubject = Rx<Subjects?>(null);
  var authorName = ''.obs;
  var pdf_link = ''.obs;
  var coverImage_link = ''.obs;
  var selectedStandard = '1'.obs;
  var cnameText = TextEditingController();
  var cnumberText = TextEditingController();
  var isValid = false.obs;
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  SolutionModel? solutionModel;
  BoardModel? boardModel;
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

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void addSolution() async {
    isAdding(true);
    var map = {
      'name': selectedSubject.value!.name.toString(),
      'std': selectedStandard.value,
      'board': selectedBoard.value!.id,
      'chapter_no': cnumberText.text,
      'chapter_name': cnameText.text
    };
    await SolutionRepository()
        .addSolution(map, coverImage_link.value, pdf_link.value);

    isAdding(false);
  }

  void clearForm() {
    selectedBoard = Rx<Boards?>(null);
    selectedStandard = '1'.obs;
    pdf_link = ''.obs;
    coverImage_link = ''.obs;
    selectedSubject = Rx<Subjects?>(null);
    isValid.value = false;
  }

  void deleteSolution(int id) async {
    isLoading(true);
    await SolutionRepository().deleteSolution(id);
    isLoading(false);
    fetchData();
  }

  void fetchData() async {
    isLoading(true);
    solutionModel = await SolutionRepository().getSolutions();
    boardModel = await BookRepository().getBoard();
    subjectModel = await BookRepository().getSubject();
    isLoading(false);
  }
}
