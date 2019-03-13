import 'dart:convert';

///手动json解析
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        email = json['email'];


  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
      };
}

void main(){
  String jsonStr = '{"name":"guoyuanzhuang","email":"guoyuanzhuang@gmail.com"}';
  Map<String, dynamic> userMap = json.decode(jsonStr);
  print('name>>${userMap['name']}');
  print('name>>${userMap['email']}');

  var user = new User.fromJson(userMap);
  print('${user.name}');
  print('${user.email}');

  print(user.toJson());
}