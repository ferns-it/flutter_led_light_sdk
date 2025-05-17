package com.example.flutter_led_light_sdk

import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import com.example.flutter_led_light_sdk.Service.LedLightService
import com.ys.serialport.LightController
import com.ys.serialport.LightController.Led
import com.ys.serialport.SerialPort
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class FlutterLightController(private val context: Context) {
    private var lightController: LightController = LightController.getInstance()

    private val LOG_TAG = "Flutter Led Light SDK"


    private val colorsMap: Map<String, Triple<Int, Int, Int>> = mapOf(
        "Red1" to Triple(255, 23, 4),
        "Pink" to Triple(255, 46, 192),
        "Purple" to Triple(29, 0, 166),
        "Magenta" to Triple(192, 8, 171),
        "Violet" to Triple(153, 31, 194),
        "SkyBlue" to Triple(55, 170, 223),
        "Green1" to Triple(18, 172, 45),
        "Green2" to Triple(62, 197, 89),
        "Yellow" to Triple(252, 217, 0),
        "Blue" to Triple(0, 0, 255),
        "Green3" to Triple(0, 255, 0),
        "Cyan" to Triple(0, 255, 255)
    )


    fun getDevices(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val devices: Array<String> = SerialPort.getDevices()
                val devicesList: List<String> = devices.toList()
                withContext(Dispatchers.Main) {
                    result.success(devicesList)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("GET_DEVICES_ERROR", e.message, null)
                }
            }
        }
    }


    fun getRates(result: Result) {
        val rates = SerialPort.RATES.map { it.toInt() }.toIntArray()
        result.success(rates)
    }


    fun getColorsMap(result: Result) {
        val serializedColorsMap: Map<String, List<Int>> = colorsMap.mapValues { (_, triple) ->
            listOf(triple.first, triple.second, triple.third)
        }
        // In Flutter Side, Map<String, List<int>> colorsMap = await methodChannel.invokeMethod('getColorsMap');
        result.success(serializedColorsMap)
    }


    fun openDevice(call: MethodCall, result: Result) {
        try {
            val device = call.argument<String>("device")
            val rate = call.argument<Int>("rate")
            if (device != null && rate != null) {
                lightController.close()
                lightController.openDevice(context, device, rate)
                result.success(true)
            } else {
                result.error("INVALID_ARGUMENTS", "Device or rate is missing or invalid", null)
            }
        } catch (e: Exception) {
            // Handle the exception appropriately, you can log it or take other actions.
            result.error("DEVICE_OPEN_ERROR", "Error opening device: ${e.message}", null)
        }
    }


    fun closeDevice(result: Result) {
        try {
            lightController.close()
            result.success(true)
        } catch (e: Exception) {
            result.error("DEVICE_CLOSE_ERROR", "Error closing device: ${e.message}", null)
        }
    }

    fun setLightWithColorName(call: MethodCall, result: Result) {
        try {
            val colorName = call.argument<String>("colorName")
            val colors = colorsMap[colorName]

            if (colors != null) {
                adjustColors(colors.first, colors.second, colors.third)
                result.success(true)
            } else {
                Log.d(LOG_TAG, "Color not found in this list")
                result.error("COLOR_NOT_FOUND", "Color not found in this list", null)
            }

        } catch (e: Exception) {
            result.error("SET_LIGHT_ERROR", "Error setting light: ${e.message}", null)
        }
    }


    fun setLightWithRGB(call: MethodCall, result: Result) {
        try {
            val red = call.argument<Int>("red")
            val green = call.argument<Int>("green")
            val blue = call.argument<Int>("blue")

            if (red != null && green != null && blue != null) {
                adjustColors(red, green, blue)
                result.success(true)
            } else {
                Log.d(LOG_TAG, "Invalid RGB values")
                result.error("INVALID_RGB_VALUES", "Invalid RGB values", null)
            }

        } catch (e: Exception) {
            result.error("SET_LIGHT_ERROR", "Error setting light: ${e.message}", null)
        }
    }


    private fun adjustColors(red: Int, green: Int, blue: Int) {
        Thread {
            lightController.keepMode(Led.RED, 0, red)
            SystemClock.sleep(20)
            lightController.keepMode(Led.GREEN, 0, green)
            SystemClock.sleep(20)
            lightController.keepMode(Led.BLUE, 0, blue)
        }.start()
    }

    fun startLightLiveMode(call: MethodCall, result: Result) {
        try {
            val lightLength = call.argument<Int>("lightLength")
            val intent = Intent(context, LedLightService::class.java)
            intent.putExtra("lightLength", lightLength)
            context.startService(intent)
            result.success(true);
        } catch (e: Exception) {
            result.error(
                "START_LIGHT_LIVE_MODE",
                "Error white starting light live mode: ${e.message}",
                null
            )
        }
    }

    fun stopLightLiveMode(result: Result) {
        try {
            val closeLeds = listOf(Led.RED, Led.GREEN, Led.BLUE)
            lightController.close(closeLeds)
            result.success(true)
        } catch (e: Exception) {
            result.error(
                "STOP_LIGHT_LIVE_MODE",
                "Error stopping light live mode: ${e.message}",
                null
            )
        }
    }


    fun startLightCrazyMode(call: MethodCall, result: Result) {
        try {
            val lightTimer = call.argument<Int>("lightTimer")
            lightController.crazyMode(lightTimer ?: 0)
            result.success(true);
        } catch (e: Exception) {
            result.error(
                "START_LIGHT_CRAZY_MODE",
                "Error white starting light crazy mode: ${e.message}",
                null
            )
        }
    }

    fun stopLightCrazyMode(result: Result) {
        try {
            val closeLeds = listOf(Led.RED, Led.GREEN, Led.BLUE)
            lightController.close(closeLeds)
            result.success(true)
        } catch (e: Exception) {
            result.error(
                "STOP_LIGHT_CRAZY_MODE",
                "Error stopping light crazy mode: ${e.message}",
                null
            )
        }
    }


    fun stopLightCrazyModeWithoutResult() {
        try {
            val intent = Intent(context, LedLightService::class.java)
            context.stopService(intent)
            lightController.close()
        } catch (e: Exception) {
            Log.e(
                LOG_TAG,
                "Error white stopping light crazy mode: ${e.message}",
                null
            )
        }
    }


    fun resumeDevice(result: Result) {
        val sp = context.getSharedPreferences("light_S", 0)
        val command = sp.getString("_command", null as String?)
        val dev = sp.getString("_dev", null as String?)
        val rate = sp.getInt("_rate", -1)

        if (!TextUtils.isEmpty(command) && !TextUtils.isEmpty(dev) && rate > 0) {
            lightController.resumeStausIfNeed(context)

            // Return the values through the method channel
            val resultMap = mapOf(
                "command" to command,
                "dev" to dev,
                "rate" to rate
            )
            return result.success(resultMap)
        }
        return result.success(null)
    }

}