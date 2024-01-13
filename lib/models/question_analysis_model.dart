class QuestionAnalysisModel {
  int? mcq;
  int? long;
  int? total;
  int? short;
  int? trueFalse;
  int? blank;
  int? onetwo;

  QuestionAnalysisModel(
      {this.mcq,
      this.long,
      this.total,
      this.short,
      this.trueFalse,
      this.blank,
      this.onetwo});

  QuestionAnalysisModel.fromJson(Map<String, dynamic> json) {
    mcq = json['mcq'];
    total = json['total'];
    long = json['long'];
    short = json['short'];
    trueFalse = json['true&false'];
    blank = json['blank'];
    onetwo = json['onetwo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mcq'] = mcq;
    data['total'] = total;
    data['long'] = long;
    data['short'] = short;
    data['true&false'] = trueFalse;
    data['blank'] = blank;
    data['onetwo'] = onetwo;
    return data;
  }
}
