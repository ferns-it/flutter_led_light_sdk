package com.example.flutter_led_light_sdk.Service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;

import com.ys.serialport.LightController;


public class LedLightService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        liveLightModel();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        lightLength = intent.getIntExtra("liveLightLength", 2);
        if (lightLength == 2) {
            intervalTime = lightLength * 1000 + 2000;
        } else {
            intervalTime = lightLength * 1000 + 500;
        }
        t.start();
        return super.onStartCommand(intent, flags, startId);
    }

    boolean lightLoop = true;
    int lightLength = 2;
    Thread t;
    int intervalTime;

    private void liveLightModel() {
        Log.d("Flutter Led Light SDK", "Live Light Model Called");
        t = new Thread(() -> {
            try {
                LightController lightController = LightController.getInstance();
                LightController.Led[] leds = {LightController.Led.RED, LightController.Led.GREEN};

                while (lightLoop) {
                    for (LightController.Led led : leds) {
                        if (!lightLoop) {
                            break; // Exit the loop if lightLoop becomes false
                        }
                        Log.d("Flutter Led Light SDK", "Still Calling....");
                        lightController.liveMode(led, lightLength);
                        SystemClock.sleep(intervalTime);
                    }
                }
            } catch (Exception e) {
                // Handle exceptions here, you can log the exception or perform other actions.
                Log.e("Flutter Led Light SDK", "Exception in liveLightModel: " + e.getMessage());
            }
        });
    }


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        lightLoop = false;
        if (t != null) t.interrupt();
    }
}
