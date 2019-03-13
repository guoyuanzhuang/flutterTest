import 'RSAKeyUtil.dart';
import 'package:pointycastle/pointycastle.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class RSAUtil{

  static RSAPublicKey publicKey;

  static RSAPrivateKey privateKey;

  static RSAUtil instance;

  ///单例
  static RSAUtil getInstance(String publicKeyFile, String privateKeyFile) {
    if (instance == null) {
      print('init RSA');
      instance = new RSAUtil(publicKeyFile, privateKeyFile);
    }
    return instance;
  }

  ///保证PEM证书只被解析一次
  RSAUtil(String publicKeyFile, String privateKeyFile){
    RSAKeyUtil keyUtil = RSAKeyUtil();
    if(publicKeyFile != null){
      publicKey = keyUtil.parse(publicKeyFile);
    }
    if(privateKeyFile != null){
      privateKey = keyUtil.parse(publicKeyFile);
    }
  }

  /*///单例
  static RSAUtil getInstance(File publicKeyFile, File privateKeyFile) {
    if (instance == null) {
      print('init RSAUtil');
      instance = new RSAUtil(publicKeyFile, privateKeyFile);
    }
    return instance;
  }
  ///保证PEM证书只被解析一次
  RSAUtil(File publicKeyFile, File privateKeyFile){
    RSAKeyUtil keyUtil = RSAKeyUtil();
    if(publicKeyFile != null){
      publicKey = keyUtil.parse(publicKeyFile.readAsStringSync());
    }

    if(privateKeyFile != null){
      privateKey = keyUtil.parse(privateKeyFile.readAsStringSync());
    }
  }*/

  ///RSA公钥加密
  encrypt(String data){
    try{
      var keyParameter = () => new PublicKeyParameter<RSAPublicKey>(publicKey);
      AsymmetricBlockCipher cipher = new AsymmetricBlockCipher("RSA/PKCS1");
      cipher.reset();
      cipher.init(true, keyParameter());
      Uint8List encryptResult = cipher.process(utf8.encode(data));
      String encrypted = _formatBytesAsHexString(encryptResult);
//      print("RSA Encrypted: $encrypted");
      return encrypted;
    }catch(e){
      print(e.toString());
    }
  }

  ///RSA私钥解密
  decrypt(String data){
    try{
      var keyParameter = () => new PrivateKeyParameter<RSAPrivateKey>(privateKey);
      AsymmetricBlockCipher cipher = new AsymmetricBlockCipher("RSA/PKCS1");
      cipher.reset();
      cipher.init(false, keyParameter());
      final hexString = _createUint8ListFromHexString(data);
      final decrypted = cipher.process(hexString);
      return decrypted;
    }catch(e){
      print(e.toString());
    }
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

  /// Converts a hexdecimal representation to binary data.
  static Uint8List _createUint8ListFromHexString(String hex) {
    var result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      var num = hex.substring(i, i + 2);
      var byte = int.parse(num, radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }
}