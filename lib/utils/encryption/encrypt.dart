library encrypt;

import 'dart:convert';

import 'package:flutter_app/utils/encryption/helpers.dart';

export 'rsa.dart';
export 'helpers.dart';

///实现了 通过PEM公钥/私钥进行RSA的加解密
///PEM公钥生成命令：openssl x509 -inform der -in ddsc_debug.crt -pubkey -noout > ddsc_debug_public_key.pem

/// Interface for the Algorithms.
abstract class Algorithm {
  /// Encrypt [plainText] to a hexdecimal representation.
  String encrypt(String plainText);

  /// Decrypt [cipherText] from a hexdecimal representation.
  String decrypt(String cipherText);
}

/// Wraps Algorithms in a unique Container.
class Encrypter {
  final Algorithm algo;

  Encrypter(this.algo);

  /// Calls [encrypt] on the wrapped Algorithm.
  String encrypt(String plainText) {
    return algo.encrypt(plainText);
  }

  /// Calls [decrypt] on the wrapped Algorithm.
  String decrypt(String cipherText) {
    return algo.decrypt(cipherText);
  }
}

/// Swap bytes representation from hexdecimal to Base64.
String from16To64(String hex) {
  final bytes = createUint8ListFromHexString(hex);
  return base64.encode(bytes);
}

/// Swap bytes representation from Base64 to hexdecimal.
String from64To16(String encoded) {
  final bytes = base64.decode(encoded);
  return formatBytesAsHexString(bytes);
}
