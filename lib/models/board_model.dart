class BoardModel {
  List<Boards>? boards;

  BoardModel({this.boards});

  BoardModel.fromJson(Map<String, dynamic> json) {
    if (json['boards'] != null) {
      boards = <Boards>[];
      json['boards'].forEach((v) {
        boards!.add(Boards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (boards != null) {
      data['boards'] = boards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Boards {
  int? id;
  String? name;
  String? coverLink;

  Boards({this.id, this.name, this.coverLink});

  Boards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coverLink = json['cover_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover_link'] = coverLink;
    return data;
  }
}
