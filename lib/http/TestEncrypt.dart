import 'AESUtil.dart';
import 'RSAUtil.dart';
import 'dart:typed_data';
import 'dart:io';
import 'httpRequest.dart';
import 'PostResponseHandler.dart';
import 'dart:convert';
import 'dart:math';
import '../utils/stringUtils.dart';
import 'package:flutter_app/model/BaseEntity.dart';
import 'package:flutter_app/model/Login.dart';
import '../utils/MD5Util.dart';
import 'dart:ui';

void main(){
  ///AES加解密
  /*final aesKey = 'add29f18e8b162ce';
  final aesData = '123456';
  print(aesData);
  String aesEncrypt = AESUtil.encrypt2Base64(aesKey, aesData);
  print('aesEncrypt: $aesEncrypt');
  String aesDecrypt = AESUtil.decrypt2Base64(aesKey, aesEncrypt);
  print('aesDecrypt: $aesDecrypt');*/

  ///RSA加解密
  /*final rsaData = 'ddsc2019';
  final publicKeyFile = File('raw/ddsc_debug_public_key.pem');
  RSAUtil rsaUtil = RSAUtil.getInstance(publicKeyFile, null);
  String rsaEncrypt = rsaUtil.encrypt(rsaData);
  print('rsaEncrypt: $rsaEncrypt');*/
  //没有私钥文件无法解密

  ///UUID
  /*var uuid = new Uuid();
  print(uuid.v1());
  print(StringUtils.getRandomString(16));
  print(StringUtils.getRandomString(32));*/

  ///MD5
//  print(MD5Util.getLoginMD5("123456"));

  ///http get请求
//  HttpRequest.getAppResource('COMMON_CONFIG').then((data){
//    print(data);
//  });

  ///http post请求
//  HttpRequest.checkPhone('18872660007', null).then((data){
//    print("Post Response>>>$data");
//    Login login = Login.fromJson(data);
//    print(login.returnCode);
//    print(login.result);
//    print(login.needRegister);
//  });
}