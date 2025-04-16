// ignore_for_file: non_constant_identifier_names, constant_identifier_names, unnecessary_string_escapes, depend_on_referenced_packages

import 'package:logger/logger.dart';

class Constants {
  static var isConnected = true;
  static const MESSAGE_NO_INTERNET =
      "You are not connceted to internet. Please turn on wifi or mobile internet then try again.";
}

final logger = Logger();
