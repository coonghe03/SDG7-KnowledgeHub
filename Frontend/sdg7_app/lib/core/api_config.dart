// lib/core/api_config.dart
import 'package:flutter/foundation.dart' show kIsWeb;
// Only import dart:io on non-web platforms
// (safe because we never touch Platform when kIsWeb == true)
import 'dart:io' show Platform;

class ApiConfig {
  // Set to true only when testing on a real phone over Wi-Fi
  static const bool useLanIp = false;
  static const String lanIp = '192.168.1.25'; // change if you use real device

  static String get baseUrl {
    String host;

    if (useLanIp) {
      host = lanIp; // real device hits your PC IP
    } else if (kIsWeb) {
      // Works in Chrome/Edge: uses the current page’s host (e.g., localhost)
      host = Uri.base.host.isEmpty ? 'localhost' : Uri.base.host;
    } else if (Platform.isAndroid) {
      host = '10.0.2.2'; // Android emulator → host machine
    } else {
      host = 'localhost'; // iOS simulator / Windows / macOS
    }

    return 'http://$host:4000/api';
  }
}
