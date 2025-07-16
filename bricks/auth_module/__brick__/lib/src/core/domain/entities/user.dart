abstract class User {
  String get id;
  String get name;
  String get email;
  String get avatar;

  Map<String, dynamic> toJson();
  User fromJson(Map<String, dynamic> json);
}
