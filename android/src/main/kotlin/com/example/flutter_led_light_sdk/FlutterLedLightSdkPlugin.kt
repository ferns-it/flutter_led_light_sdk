package com.example.flutter_led_light_sdk


import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.flutter_led_light_sdk.Service.LedLightService
import com.ys.serialport.LightController
import com.ys.serialport.SerialPort
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

            else -> result.notImplemented()
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
