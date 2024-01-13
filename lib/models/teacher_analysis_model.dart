class TeacherAnalysisModel {
  int? active;
  int? pending;
  int? monthlyUsers;
  int? dailyUsers;
  Chart? chart;

  TeacherAnalysisModel(
      {this.active,
      this.pending,
      this.monthlyUsers,
      this.dailyUsers,
      this.chart});

  TeacherAnalysisModel.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    pending = json['pending'];
    monthlyUsers = json['monthly_users'];
    dailyUsers = json['daily_users'];
    chart = json['chart'] != null ? Chart.fromJson(json['chart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['pending'] = pending;
    data['monthly_users'] = monthlyUsers;
    data['daily_users'] = dailyUsers;
    if (chart != null) {
      data['chart'] = chart!.toJson();
    }
    return data;
  }
}

class Chart {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;
  int? i6;
  int? i7;
  int? i8;
  int? i9;
  int? i10;
  int? i11;
  int? i12;

  Chart(
      {this.i1,
      this.i2,
      this.i3,
      this.i4,
      this.i5,
      this.i6,
      this.i7,
      this.i8,
      this.i9,
      this.i10,
      this.i11,
      this.i12});

  Chart.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
    i6 = json['6'];
    i7 = json['7'];
    i8 = json['8'];
    i9 = json['9'];
    i10 = json['10'];
    i11 = json['11'];
    i12 = json['12'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = i1;
    data['2'] = i2;
    data['3'] = i3;
    data['4'] = i4;
    data['5'] = i5;
    data['6'] = i6;
    data['7'] = i7;
    data['8'] = i8;
    data['9'] = i9;
    data['10'] = i10;
    data['11'] = i11;
    data['12'] = i12;
    return data;
  }
}
