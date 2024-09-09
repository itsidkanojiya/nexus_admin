// book_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/book_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';

class BookController extends GetxController {
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
  BookModel? bookModel;
  BoardModel? boardModel;

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

  void addSubject() async {
    isAdding(true);
    var map = {'name': subjectText.text.toString()};
    await BookRepository().addSubject(map);

    isAdding(false);
  }

  void deleteBook(int id) async {
    isLoading(true);
    await BookRepository().deleteBook(id);
    isLoading(false);
    fetchData();
  }

  void addBook() async {
    isAdding(true);
    var map = {
      'name': selectedSubject.value!.name.toString(),
      'std': selectedStandard.value,
      'board': selectedBoard.value!.id,
      'chapter_no': cnumberText.text,
      'chapter_name': cnameText.text,
    };
    await BookRepository().addBook(map, coverImage_link.value, pdf_link.value);

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

  void fetchData() async {
    isLoading(true);
    bookModel = await BookRepository().getBooks();
    boardModel = await BookRepository().getBoard();
    subjectModel = await BookRepository().getSubject();
    isLoading(false);
  }
}
