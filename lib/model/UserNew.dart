import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'UserNew.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;

  User(this.name, this.email);
}

void main(){
  print(_$UserToJson(new User('aa', 'bb'))) ;
}