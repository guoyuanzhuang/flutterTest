import 'package:pointycastle/pointycastle.dart';
import "dart:convert";
import "dart:typed_data";
import 'dart:io';
import 'encrypt.dart';

void main(){

  final key = new Uint8List.fromList("add29f18e8b162ce".codeUnits);
  var message = "123456";
  print("Key: $key");
  print("Message: $message");
//  var iv = new Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
//  CipherParameters params = new PaddedBlockCipherParameters(
//      new ParametersWithIV(new KeyParameter(key), iv), null);
  CipherParameters params = new PaddedBlockCipherParameters(
      new KeyParameter(key), null);

  ////////////////
  // Encrypting //
  ////////////////
  BlockCipher encryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
  encryptionCipher.init(true, params);
  Uint8List encrypted = encryptionCipher.process(utf8.encode(message));
  String content = new Base64Encoder().convert(encrypted);
  print("Encrypted: $content");


  ////////////////
  // Decrypting //
  ////////////////
  BlockCipher decryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
  decryptionCipher.init(false, params);
  String decrypted = utf8.decode(decryptionCipher.process(encrypted));
  print("Decrypted: $decrypted");

  ////////////////
  // RSA Encrypting
  ////////////////

  /*var modulus = BigInt.parse(
      "19241983703146088839455382013465012649421796633518413572587256686839760383015652660474208987130849744069746242933165161102446124329135451901608052796031902549813366685211354396735955828880698758548436076648355856625734927566412703762336707634962402277273728703366050110784585817471454904429609161371504766673447720809493081597343465839829600291938800446183110814067846470670739469788670517274650886631446466686624638216964124217561417302234542228077198849036144998505991587861363963177619916951197795690063096186761321807884158228857705576101822684318172985060993972813947611536961951562369174286143558741155400632197");
  var publicExponent = BigInt.parse("65537");
  var pubk = new RSAPublicKey(modulus, publicExponent);
  var pubpar = () => new PublicKeyParameter<RSAPublicKey>(pubk);

  AsymmetricBlockCipher cipher = new AsymmetricBlockCipher("RSA/PKCS1");
  cipher.reset();
  cipher.init(true, pubpar());
  Uint8List encryptResult = cipher.process(utf8.encode(message));
  print("RSA Encrypted: \n" + HEX.encode(encryptResult));*/

  final publicKeyFile = File('raw/ddsc_debug_public_key.pem');
  final parser = new RSAKeyParser();
  final RSAPublicKey publicKey = parser.parse(publicKeyFile.readAsStringSync());
  final encrypter = Encrypter(RSA(publicKey, null));
  final encryptedText = encrypter.encrypt(message);
  print("RSA Encrypted Pem: \n" + encryptedText);

}









