import 'package:dart_des/dart_des.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String encrypt(String value,  {bool isNumber = false}) {
  
  final String cKey = dotenv.env['C_KEY'] ?? '';
  final des = DES(
    key: cKey.codeUnits,
    mode: DESMode.CBC,
    iv: cKey.codeUnits,
    paddingType: DESPaddingType.PKCS7,
  );
  final encrypted = des.encrypt(value.codeUnits);
  return base64.encode(encrypted);
}