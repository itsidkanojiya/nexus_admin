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
  String? board;
  String? pdfLink;
  String? coverLink;
  String? createdAt;
  void updatedAt;
  void deletedAt;

  Solutions(
      {this.id,
      this.name,
      this.std,
      this.board,
      this.pdfLink,
      this.coverLink,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    std = json['std'];
    board = json['board'];
    pdfLink = json['pdf_link'];
    coverLink = json['cover_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['std'] = std;
    data['board'] = board;
    data['pdf_link'] = pdfLink;
    data['cover_link'] = coverLink;
    data['created_at'] = createdAt;

    return data;
  }
}
