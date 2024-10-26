class SolutionModel {
  List<Solutions>? solutions;

  SolutionModel({this.solutions});

  SolutionModel.fromJson(Map<String, dynamic> json) {
    if (json['solutions'] != null) {
      solutions = <Solutions>[];
      json['solutions'].forEach((v) {
        solutions!.add(Solutions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (solutions != null) {
      data['solutions'] = solutions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Solutions {
  int? id;
  String? name;
  int? std;
  int? chapterNo;
  String? chapterName;
  String? pdfLink;
  String? coverLink;
  String? createdAt;
  String? updatedAt;
  void deletedAt;
  int? boardId;
  int? subjectId;
  String? boardName;
  String? subjectName;

  Solutions(
      {this.id,
      this.name,
      this.std,
      this.chapterNo,
      this.chapterName,
      this.pdfLink,
      this.coverLink,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.boardId,
      this.subjectId,
      this.boardName,
      this.subjectName});

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    std = json['std'];
    chapterNo = json['chapter_no'];
    chapterName = json['chapter_name'];
    pdfLink = json['pdf_link'];
    coverLink = json['cover_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    boardId = json['board_id'];
    subjectId = json['subject_id'];
    boardName = json['board_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['std'] = std;
    data['chapter_no'] = chapterNo;
    data['chapter_name'] = chapterName;
    data['pdf_link'] = pdfLink;
    data['cover_link'] = coverLink;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['board_id'] = boardId;
    data['subject_id'] = subjectId;
    data['board_name'] = boardName;
    data['subject_name'] = subjectName;
    return data;
  }
}
