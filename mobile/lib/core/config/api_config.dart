import 'dart:io';

import 'package:flutter/foundation.dart';

/// How the Android app reaches the Rails API on your PC.
enum AndroidConnectionMode {
  /// Emulator only — uses `10.0.2.2`.
  emulator,

  /// Real phone on same Wi-Fi — uses [pcLanIp]. Requires Windows Firewall to allow port 3000.
  physicalDevice,

  /// Real phone over USB — run `adb reverse tcp:3000 tcp:3000` first, then uses `127.0.0.1`.
  usbAdbReverse,
}

class ApiConfig {
  ApiConfig._();

  static const int connectTimeoutMs = 30000;
  static const int receiveTimeoutMs = 60000;

  /// Change this based on how you run the app.
  /// Use [physicalDevice] on a real phone; [emulator] only inside Android emulator.
  static const AndroidConnectionMode androidMode = AndroidConnectionMode.physicalDevice;

  /// Your PC IPv4 from `ipconfig` / `ifconfig` (active Wi-Fi or Ethernet adapter).
  /// Only used when [androidMode] is [AndroidConnectionMode.physicalDevice].
  /// Example: `192.168.1.42` — replace with YOUR machine's address.
  static const String pcLanIp = '10.162.10.243';

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api/v1';
    if (Platform.isAndroid) {
      return 'http://$_androidHost:3000/api/v1';
    }
    return 'http://localhost:3000/api/v1';
  }

  static String get _androidHost {
    switch (androidMode) {
      case AndroidConnectionMode.emulator:
        return '10.0.2.2';
      case AndroidConnectionMode.physicalDevice:
        return pcLanIp;
      case AndroidConnectionMode.usbAdbReverse:
        return '127.0.0.1';
    }
  }
}
