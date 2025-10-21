import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiConfig {
  static const bool useLanIp = true; // <— set TRUE
  static const String lanIp = '127.0.0.1'; // <— your PC IPv4

  static String get baseUrl {
    String host;
    if (useLanIp) {
      host = lanIp;
    } else if (kIsWeb) {
      host = Uri.base.host.isEmpty ? 'localhost' : Uri.base.host;
    } else if (Platform.isAndroid) {
      host = '10.0.2.2';
    } else {
      host = 'localhost';
    }
    return 'http://$host:4000/api';
  }
}
