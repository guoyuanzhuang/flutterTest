import 'BaseEntity.dart';

class Login extends BaseEntity{
  bool needRegister;

  Login.fromJson(Map<String, dynamic> json) :
        super.fromJson(json) {
    needRegister = result['needRegister'];
  }
}
