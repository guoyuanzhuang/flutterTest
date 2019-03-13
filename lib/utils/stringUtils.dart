import 'dart:math';
import 'dart:convert';

class StringUtils{

  ///length表示生成字符串的长度
  static getRandomString(int length) {
    var base = "abcdefghijklmnopqrstuvwxyz0123456789";
    var random = new Random();
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < length; i++) {
      int number = random.nextInt(base.length);
      sb.write(String.fromCharCode(base.codeUnitAt(number)));
    }
    return sb.toString();
  }
}


