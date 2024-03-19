import 'dart:io';
//import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  static Future<String> getDeviceName() async {
    String deviceName = "";
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   deviceName = androidInfo.model.toString();
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   deviceName = iosInfo.name ?? "";
    // }

    return deviceName;
  }
}
