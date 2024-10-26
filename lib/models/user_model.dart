class UsersModel {
  List<Users>? users;

  UsersModel({this.users});

  UsersModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? number;
  int? std;
  String? school;
  String? subject;
  String? email;
  int? verified;

  Users(
      {this.id,
      this.name,
      this.number,
      this.std,
      this.school,
      this.subject,
      this.email,
      this.verified});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    std = json['std'];
    school = json['school'];
    subject = json['subject'];
    email = json['email'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['std'] = std;
    data['school'] = school;
    data['subject'] = subject;
    data['email'] = email;
    data['verified'] = verified;
    return data;
  }
}
