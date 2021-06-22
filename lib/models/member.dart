class Member {
  final String name;
  String id;
  final String total;
  final String weeks;

  Member({this.name, this.total, this.weeks, this.id});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        name: json['name'] as String,
        id: json['id']as String,
        total: json['total']as String,
        weeks: json['weeks']as String,);
  }
}
