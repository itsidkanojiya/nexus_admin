import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/module/analysis/analysis_view.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/module/books/book_view.dart';
import 'package:lexus_admin/module/change_subject/change_subject_view.dart';
import 'package:lexus_admin/module/home/home_view.dart';
import 'package:lexus_admin/module/quetions/Blanks/blank_view.dart';
import 'package:lexus_admin/module/quetions/Long/long_view.dart';
import 'package:lexus_admin/module/quetions/Mcq/mcq_view.dart';
import 'package:lexus_admin/module/quetions/One%20Two/onetwo_view.dart';
import 'package:lexus_admin/module/quetions/Short/short_view.dart';
import 'package:lexus_admin/module/quetions/T%20&%20F/true_false_view.dart';
import 'package:lexus_admin/module/solutions/solution_view.dart';
import 'package:lexus_admin/module/student/student_view.dart';
import 'package:lexus_admin/module/teacher/active_view.dart';
import 'package:lexus_admin/module/teacher/pending_view.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Obx(() {
      switch (AuthService.indexValue.value) {
        case 0:
          return AnalysisView();
        case 1:
          return AuthService.subTeacherIndex.value == 0
              ? PendingTeacherView()
              : ActiveTeacherView();
        case 2:
          return StudentView();
        case 3:
          return ChangeSubjectView();
        case 4:
          return BookView();
        case 5:
          return SolutionView();
        case 6:
          return getQuetionView();
        default:
          return HomeView();
      }
    })));
  }

  getQuetionView() {
    switch (AuthService.subQuetionIndex.value) {
      case 0:
        return McqView();
      case 1:
        return BlankView();
      case 2:
        return TrueOrFalseView();
      case 3:
        return OneTwoView();
      case 4:
        return ShortView();
      case 5:
        return LongView();
      default:
        return HomeView();
    }
  }
}
