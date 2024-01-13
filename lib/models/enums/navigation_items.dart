import 'package:flutter/material.dart';

enum NavigationItems {
  dashBoard,
  teachers,
  srudents,
  books,
  quetions,
}

extension NavigationItemsExtensions on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.dashBoard:
        return Icons.pie_chart;
      case NavigationItems.teachers:
        return Icons.people;
      case NavigationItems.srudents:
        return Icons.man;
      case NavigationItems.books:
        return Icons.menu_book_sharp;
      case NavigationItems.quetions:
        return Icons.question_mark_outlined;
      default:
        return Icons.person;
    }
  }
}
