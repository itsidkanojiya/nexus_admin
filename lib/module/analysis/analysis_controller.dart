import 'package:get/get.dart';
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/question_analysis_model.dart';
import 'package:lexus_admin/models/student_analysis_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/models/teacher_analysis_model.dart';
import 'package:lexus_admin/repository/analysis_repository.dart';
import 'package:lexus_admin/repository/book_repository.dart';

class AnalysisController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  TeacherAnalysisModel? teacherAnalysisModel;
  StudentAnalysisModel? studentAnalysisModel;
  QuestionAnalysisModel? questionAnalysisModel;
  SubjectModel? subjectModel;
  BoardModel? boardModel;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    teacherAnalysisModel = await AnalysisRepository().getTeacherAnalysis();
    studentAnalysisModel = await AnalysisRepository().getStudentAnalysis();
    questionAnalysisModel = await AnalysisRepository().getQuestionAnalysis();
    boardModel = await BookRepository().getBoard();
    subjectModel = await BookRepository().getSubject();
    isLoading(false);
  }
}
