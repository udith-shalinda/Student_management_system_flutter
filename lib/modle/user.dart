class User {
  String id;
  String type;

  User({this.id, this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["userId"] as String,
      type: json["type"] as String,
    );
  }
}