import 'dart:convert';
import "dart:typed_data";
import 'package:pointycastle/pointycastle.dart';

///
/// AES加解密封装
/// by guoyuanzhuang@ddsoucai.cn  2019.01.19
///
class AESUtil{

  ///AES+Base64加密
  static encrypt2Base64(String keyStr, String data){
    Uint8List encrypted = encrypt(keyStr, data);
    String content = new Base64Encoder().convert(encrypted);
//    print("Encrypted: $content");
    return content;
  }

  ///AES+Base64解密
  static decrypt2Base64(String keyStr, String data){
    String newData = data.replaceAll(new RegExp("\n"), "");
    Uint8List decrypted = new Base64Decoder().convert(newData);
    String content = decrypt(keyStr, decrypted);
//    print("decrypted: content");
    return content;
  }

  ///AES加密
  static encrypt(String keyStr, String data){
    final key = new Uint8List.fromList(keyStr.codeUnits);
//  设置加密偏移量IV
//  var iv = new Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
//  CipherParameters params = new PaddedBlockCipherParameters(
//      new ParametersWithIV(new KeyParameter(key), iv), null);
    CipherParameters params = new PaddedBlockCipherParameters(
        new KeyParameter(key), null);
    BlockCipher encryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
    encryptionCipher.init(true, params);
    Uint8List encrypted = encryptionCipher.process(utf8.encode(data));
//    print("Encrypted: $encrypted");
    return encrypted;
  }

  ///AES解密
  static decrypt(String keyStr, Uint8List data){
    final key = new Uint8List.fromList(keyStr.codeUnits);
    CipherParameters params = new PaddedBlockCipherParameters(
        new KeyParameter(key), null);
    BlockCipher decryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
    decryptionCipher.init(false, params);
    String decrypted = utf8.decode(decryptionCipher.process(data));
//    print("Decrypted: $decrypted");
    return decrypted;
  }
}