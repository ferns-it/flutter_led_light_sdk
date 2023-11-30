package com.example.flutter_led_light_sdk


import android.content.Context

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterLedLightSdkPlugin */
class FlutterLedLightSdkPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private lateinit var flutterLightController: FlutterLightController

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_led_light_sdk")
        context = flutterPluginBinding.applicationContext
        flutterLightController = FlutterLightController(context)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getDevices" -> {
                flutterLightController.getDevices(result)
            }

            "getRates" -> {
                flutterLightController.getRates(result)
            }

            "getColorsMap" -> {
                flutterLightController.getColorsMap(result)
            }

            "openDevice" -> {
                flutterLightController.openDevice(call, result)
            }

            "closeDevice" -> {
                flutterLightController.closeDevice(result)
            }

            "setLightWithColorName" -> {
                flutterLightController.setLightWithColorName(call, result)
            }

            "setLightWithRGB" -> {
                flutterLightController.setLightWithRGB(call, result)
            }

            "resumeDevice" -> {
                flutterLightController.resumeDevice(result)
            }

            "startLightCrazyMode" -> {
                flutterLightController.startLightCrazyMode(call, result)
            }

            "stopLightCrazyMode" -> {
                flutterLightController.stopLightCrazyMode(result)
            }

            "startLightLiveMode" -> {
                flutterLightController.startLightLiveMode(call, result)
            }

            "stopLightLiveMode" -> {
                flutterLightController.stopLightLiveMode(result)
            }

            else -> result.notImplemented()
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterLightController.stopLightCrazyModeWithoutResult();
        channel.setMethodCallHandler(null)
    }
}
