class ChangeSubjectModel {
  int? id;
  String? name;
  String? email;
  String? subject;
  String? requestedSubject;

  ChangeSubjectModel(
      {this.id, this.name, this.email, this.subject, this.requestedSubject});

  ChangeSubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    subject = json['subject'];
    requestedSubject = json['requested_subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['subject'] = subject;
    data['requested_subject'] = requestedSubject;
    return data;
  }
}
