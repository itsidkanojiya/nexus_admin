class McqModel {
  List<Questions>? questions;

  McqModel({this.questions});

  McqModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? board;
  String? subject;
  int? std;
  int? chapter;
  String? question;
  String? answer;
  String? solution;
  String? createdAt;
  String? updatedAt;
  void deletedAt;
  String? type;
  List<String>? options;
  String? boardName;

  Questions(
      {this.id,
      this.board,
      this.subject,
      this.std,
      this.chapter,
      this.question,
      this.answer,
      this.solution,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.type,
      this.options,
      this.boardName});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    board = json['board'];
    subject = json['subject'];
    std = json['std'];
    chapter = json['chapter'];
    question = json['question'];
    answer = json['answer'];
    solution = json['solution'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    type = json['type'];
    options = json['options'].cast<String>();
    boardName = json['board_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['board'] = board;
    data['subject'] = subject;
    data['std'] = std;
    data['chapter'] = chapter;
    data['question'] = question;
    data['answer'] = answer;
    data['solution'] = solution;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['type'] = type;
    data['options'] = options;
    data['board_name'] = boardName;
    return data;
  }
}