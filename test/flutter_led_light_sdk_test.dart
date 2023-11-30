import 'package:flutter_led_light_sdk/flutter_led_light_sdk_method_channel.dart';
import 'package:flutter_led_light_sdk/flutter_led_light_sdk_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLedLightSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLedLightSdkPlatform {
  @override
  Future<List<int>> getRates() {
    // TODO: implement getRates
    throw UnimplementedError();
  }

  @override
  Future<bool> closeDevice() {
    // TODO: implement closeDevice
    throw UnimplementedError();
  }

  @override
  Future<Map<String, List<int>>?> getColorsMap() {
    // TODO: implement getColorsMap
    throw UnimplementedError();
  }

  @override
  Future<List<String?>> getDevices() {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  @override
  Future<bool> openDevice(String device, int rate) {
    // TODO: implement openDevice
    throw UnimplementedError();
  }

  @override
  Future<bool> setLightWithColorName(String colorName) {
    // TODO: implement setLightWithColorName
    throw UnimplementedError();
  }

  @override
  Future<bool> startLightCrazyMode([int lightLength = 2]) {
    // TODO: implement startLightCrazyMode
    throw UnimplementedError();
  }

  @override
  Future<bool> stopLightCrazyMode() {
    // TODO: implement stopLightCrazyMode
    throw UnimplementedError();
  }

  @override
  Future<bool> startLightLiveMode(int lightLength) {
    // TODO: implement startLightLiveMode
    throw UnimplementedError();
  }

  @override
  Future<bool> stopLightLiveMode() {
    // TODO: implement stopLightLiveMode
    throw UnimplementedError();
  }

  @override
  Future<bool> setLightWithRGB(int red, int green, int blue) {
    // TODO: implement setLightWithRGB
    throw UnimplementedError();
  }
}

void main() {
  final FlutterLedLightSdkPlatform initialPlatform =
      FlutterLedLightSdkPlatform.instance;

  test('$MethodChannelFlutterLedLightSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLedLightSdk>());
  });

  test('getPlatformVersion', () async {});
}
