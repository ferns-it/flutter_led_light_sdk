import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_led_light_sdk/flutter_led_light_sdk.dart';
import 'package:flutter_led_light_sdk/flutter_led_light_sdk_platform_interface.dart';
import 'package:flutter_led_light_sdk/flutter_led_light_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLedLightSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLedLightSdkPlatform {
  @override
  Future<void> closeDevice() {
    // TODO: implement closeDevice
    throw UnimplementedError();
  }

  @override
  Future<void> getColorsMap() {
    // TODO: implement getColorsMap
    throw UnimplementedError();
  }

  @override
  Future<void> openDevice() {
    // TODO: implement openDevice
    throw UnimplementedError();
  }

  @override
  Future<void> setLightWithColorName() {
    // TODO: implement setLightWithColorName
    throw UnimplementedError();
  }

  @override
  Future<List<String?>> getDevices() {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getRates() {
    // TODO: implement getRates
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
