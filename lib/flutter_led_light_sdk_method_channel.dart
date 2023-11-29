import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_led_light_sdk_platform_interface.dart';

/// An implementation of [FlutterLedLightSdkPlatform] that uses method channels.
class MethodChannelFlutterLedLightSdk implements FlutterLedLightSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_led_light_sdk');

  @override
  Future<bool> openDevice(String device, int rate) async {
    try {
      final result = await methodChannel.invokeMethod<bool>("openDevice", {
        'device': device,
        'rate': rate,
      });
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "openDevice");
      return false;
    }
  }

  @override
  Future<bool> closeDevice() async {
    try {
      final result = await methodChannel.invokeMethod<bool?>("closeDevice");
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "closeDevice");
      return false;
    }
  }

  @override
  Future<Map<String, List<Object?>>?> getColorsMap() async {
    try {
      final dynamic result = await methodChannel.invokeMethod('getColorsMap');
      if (result is Map<Object?, Object?>) {
        final colorsMap = result.cast<String, List<int>>();

        return colorsMap;
      }
      return null;
    } on Exception catch (e) {
      log(e.toString(), error: "getColorsMap");
      return null;
    }
  }

  @override
  Future<List<String?>> getDevices() async {
    try {
      final devices = await methodChannel.invokeMethod(
        'getDevices',
      ) as List<Object?>;
      return devices.cast<String?>();
    } on Exception catch (e) {
      log(e.toString(), error: "getDevices");
      return <String>[];
    }
  }

  @override
  Future<List<int>> getRates() async {
    final rates = await methodChannel.invokeMethod<List<int>>('getRates');
    return rates ?? <int>[];
  }

  @override
  Future<void> setLightWithColorName(colorName) async {
    final changed =
        await methodChannel.invokeMethod<bool>('setLightWithColorName', {
      'colorName': colorName,
    });
    log(changed.toString(), name: "changed");
  }
}
