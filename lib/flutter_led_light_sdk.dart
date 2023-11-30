// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'flutter_led_light_sdk_platform_interface.dart';

class FlutterLedLightSdk {
  Future<List<String?>> getDevices() {
    return FlutterLedLightSdkPlatform.instance.getDevices();
  }

  Future<List<int>> getRates() {
    return FlutterLedLightSdkPlatform.instance.getRates();
  }

  Future<bool> openDevice(String device, int rate) {
    return FlutterLedLightSdkPlatform.instance.openDevice(device, rate);
  }

  Future<bool> closeDevice() {
    return FlutterLedLightSdkPlatform.instance.closeDevice();
  }

  Future<Map<String, List<int>>?> getColorsMap() {
    return FlutterLedLightSdkPlatform.instance.getColorsMap();
  }

  Future<bool> setLightWithColorName(String colorName) {
    return FlutterLedLightSdkPlatform.instance.setLightWithColorName(colorName);
  }

  Future<bool> setLightWithRGB(int red, int green, int blue) {
    return FlutterLedLightSdkPlatform.instance
        .setLightWithRGB(red, green, blue);
  }

  Future<bool> startLightCrazyMode([int lightTimer = 0]) {
    return FlutterLedLightSdkPlatform.instance.startLightCrazyMode(lightTimer);
  }

  Future<bool> stopLightCrazyMode() {
    return FlutterLedLightSdkPlatform.instance.stopLightCrazyMode();
  }

  Future<bool> startLightLiveMode([int lightLength = 0]) {
    return FlutterLedLightSdkPlatform.instance.startLightLiveMode(lightLength);
  }

  Future<bool> stopLightLiveMode() {
    return FlutterLedLightSdkPlatform.instance.stopLightLiveMode();
  }
}
