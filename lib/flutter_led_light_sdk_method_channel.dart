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
  Future<Map<String, List<int>>?> getColorsMap() async {
    try {
      final dynamic result = await methodChannel.invokeMethod('getColorsMap');
      if (result is Map<Object?, Object?>) {
        final parsedMap = result.map<String, List<int>>((key, value) {
          final list = value as List<Object?>;
          final listItem1 = list[0] as int;
          final listItem2 = list[1] as int;
          final listItem3 = list[2] as int;
          return MapEntry(key as String, [listItem1, listItem2, listItem3]);
        });
        return parsedMap;
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
  Future<bool> setLightWithColorName(String colorName) async {
    final changed = await methodChannel.invokeMethod<bool>(
      'setLightWithColorName',
      {
        'colorName': colorName,
      },
    );
    return changed ?? false;
  }

  @override
  Future<bool> startLightCrazyMode(int lightTimer) async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>("startLightCrazyMode", {
        'lightTimer': lightTimer,
      });
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "startLightCrazyMode");
      return false;
    }
  }

  @override
  Future<bool> stopLightCrazyMode() async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>("stopLightCrazyMode");
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "stopLightCrazyMode");
      return false;
    }
  }

  @override
  Future<bool> startLightLiveMode(int lightLength) async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>("startLightLiveMode", {
        'lightLength': lightLength,
      });
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "startLightLiveMode");
      return false;
    }
  }

  @override
  Future<bool> stopLightLiveMode() async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        "stopLightLiveMode",
      );
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "stopLightLiveMode");
      return false;
    }
  }

  @override
  Future<bool> setLightWithRGB(int red, int green, int blue) async {
    try {
      final result = await methodChannel.invokeMethod<bool>("setLightWithRGB", {
        "red": red,
        "green": green,
        "blue": blue,
      });
      return result ?? false;
    } on Exception catch (e) {
      log(e.toString(), error: "stopLightLiveMode");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> resumeDevice() async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
        "resumeDevice",
      );
      if (result == null) return null;
      return <String, dynamic>{
        "dev": result['dev'],
        "command": result['command'],
        "rate": result["rate"]
      };
    } on Exception catch (e) {
      log(e.toString(), error: "resumeDevice");
      return null;
    }
  }
}
