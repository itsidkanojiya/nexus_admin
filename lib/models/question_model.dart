class QuestionModel {
  List<Questions>? questions;

  QuestionModel({this.questions});

  QuestionModel.fromJson(Map<String, dynamic> json) {
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
  int? bid;
  int? std;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? answer;
  String? solution;

  Questions({
    this.id,
    this.bid,
    this.std,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.answer,
    this.solution,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bid = json['bid'];
    std = json['std'];
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    answer = json['answer'];
    solution = json['solution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bid'] = bid;
    data['std'] = std;
    data['question'] = question;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['option4'] = option4;
    data['answer'] = answer;
    data['solution'] = solution;

    return data;
  }
}
