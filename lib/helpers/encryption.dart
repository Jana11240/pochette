import 'package:encrypt/encrypt.dart';

class AES256Encryption {
  final Key key;
  final IV iv;

  AES256Encryption(String keyString, String ivString)
      : key = Key.fromUtf8(keyString),
        iv = IV.fromUtf8(ivString);

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    return decrypted;
  }
}