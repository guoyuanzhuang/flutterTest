import 'dart:convert';
import "dart:typed_data";
import 'package:pointycastle/pointycastle.dart';
///
/// MD5校验
/// guoyuanzhuang@ddsoucai.cn
///
class MD5Util{

  static final md5Key = "3c3fdf2cf670614eafe8836b5e17bf13";

  static final loginPwdKey = "ffbea1a077dcd69caf625da2a555e6e5";

  static final payPwdKey = "2726825d77703b1ea2ae94e50d06bb19";

  static getLoginMD5(String content){
    String newMD5 = stringMD5(content + md5Key);
    String pwdMD5 = stringMD5(newMD5 + loginPwdKey);
    return pwdMD5;
  }

  static getPayMD5(String content){
    String newMD5 = stringMD5(content + md5Key);
    String pwdMD5 = stringMD5(newMD5 + payPwdKey);
    return pwdMD5;
  }

  static stringMD5(String content){
    Uint8List resultByte = new Digest("MD5").process(utf8.encode(content));
    return _formatBytesAsHexString(resultByte);
  }

  /// Converts binary data to a hexdecimal representation.
  static String _formatBytesAsHexString(Uint8List bytes) {
    var result = StringBuffer();
    for (var i = 0; i < bytes.lengthInBytes; i++) {
      var part = bytes[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }
}