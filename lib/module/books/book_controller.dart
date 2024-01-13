// book_controller.dart
import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/book_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/repository/book_repository.dart';

class BookController extends GetxController {
  var selectedBoard = Rx<Boards?>(null);
  var selectedSubject = Rx<Subjects?>(null);
  var authorName = ''.obs;
  var pdf_link = ''.obs;
  var coverImage_link = ''.obs;
  var selectedStandard = '1'.obs;

  var isValid = false.obs;
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  BookModel? bookModel;
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

  void addBook() async {
    isAdding(true);
    var map = {
      'name': selectedSubject.value!.name.toString(),
      'std': selectedStandard.value,
      'bid': selectedBoard.value!.id
    };
    await BookRepository().addBook(map, coverImage_link.value, pdf_link.value);

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

  void fetchData() async {
    isLoading(true);
    bookModel = await BookRepository().getBooks();
    boardModel = await BookRepository().getBoard();
    subjectModel = await BookRepository().getSubject();
    isLoading(false);
  }
}
