import 'package:fintech_dashboard_clone/models/question_analysis_model.dart';
import 'package:fintech_dashboard_clone/models/student_analysis_model.dart';
import 'package:fintech_dashboard_clone/models/teacher_analysis_model.dart';
import 'package:fintech_dashboard_clone/repository/analysis_repository.dart';
import 'package:get/get.dart';

class AnalysisController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;
  TeacherAnalysisModel? teacherAnalysisModel;
  StudentAnalysisModel? studentAnalysisModel;
  QuestionAnalysisModel? questionAnalysisModel;

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
    isLoading(false);
  }
}
