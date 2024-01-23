
class User {
  const User({
    this.id,
    this.name,
    this.lastname,
    this.username,
    this.password,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        lastname: json['lastname'] as String?,
        username: json['username'] as String?,
        password: json['password'] as String?,
      );

  final int? id;

  final String? name;

  final String? lastname;

  final String? username;

  final String? password;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'username': username,
      'password': password,
    };
  }
}
