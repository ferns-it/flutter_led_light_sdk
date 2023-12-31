import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_led_light_sdk_method_channel.dart';

abstract class FlutterLedLightSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterLedLightSdkPlatform.
  FlutterLedLightSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLedLightSdkPlatform _instance =
      MethodChannelFlutterLedLightSdk();

  /// The default instance of [FlutterLedLightSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLedLightSdk].
  static FlutterLedLightSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLedLightSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterLedLightSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<String?>> getDevices() {
    throw UnimplementedError('getDevices() has not been implemented.');
  }

  Future<List<int>> getRates() {
    throw UnimplementedError('getRates() has not been implemented.');
  }

  Future<Map<String, List<int>>?> getColorsMap() {
    throw UnimplementedError('getColorsMap() has not been implemented.');
  }

  Future<bool> openDevice(String device, int rate) {
    throw UnimplementedError('openDevice() has not been implemented.');
  }

  Future<bool> closeDevice() {
    throw UnimplementedError('closeDevice() has not been implemented.');
  }

  Future<Map<String, dynamic>?> resumeDevice() {
    throw UnimplementedError(
      'resumeDevice() has not been implemented.',
    );
  }

  Future<bool> setLightWithColorName(String colorName) {
    throw UnimplementedError(
      'setLightWithColorName() has not been implemented.',
    );
  }

  Future<bool> setLightWithRGB(int red, int green, int blue) {
    throw UnimplementedError(
      'setLightWithRGB() has not been implemented.',
    );
  }

  Future<bool> startLightCrazyMode(int lightTimer) async {
    throw UnimplementedError(
      'startLightCrazyMode() has not been implemented.',
    );
  }

  Future<bool> stopLightCrazyMode() async {
    throw UnimplementedError(
      'stopLightCrazyMode() has not been implemented.',
    );
  }

  Future<bool> startLightLiveMode(int lightLength) {
    throw UnimplementedError(
      'startLightLiveMode() has not been implemented.',
    );
  }

  Future<bool> stopLightLiveMode() {
    throw UnimplementedError(
      'stopLightLiveMode() has not been implemented.',
    );
  }
}
