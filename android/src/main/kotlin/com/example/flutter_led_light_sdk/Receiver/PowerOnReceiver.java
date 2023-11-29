package com.example.flutter_led_light_sdk.Receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.ys.serialport.LightController;

import java.util.Objects;

public class PowerOnReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(final Context context, Intent intent) {
        Log.d("Flutter Led Light SDK", "Action received");
        if (Objects.equals(intent.getAction(), Intent.ACTION_BOOT_COMPLETED)) {
            LightController.getInstance().resumeStausIfNeed(context);
        }
    }
}

