import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_led_light_sdk/flutter_led_light_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterLedLightSdkPlugin = FlutterLedLightSdk();

  List<String?> devices = [];
  List<int> rates = [];

  String? selectedDevice;
  int? selectedRate;

  bool deviceOpened = false;

  Map<String, List<Object?>>? colorsMap;

  @override
  void initState() {
    _flutterLedLightSdkPlugin.getColorsMap().then((colors) {
      setState(() {
        colorsMap = colors;
      });
    });
    super.initState();
  }

  List<int?>? getRGBValues(String colorName) {
    return colorsMap?[colorName] as List<int?>?;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: false,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter LED SDK'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    itemCount: colorsMap?.length ?? 0,
                    itemBuilder: (context, index) {
                      final colorName = colorsMap?.keys.elementAt(index);

                      if (colorName == null || colorsMap == null) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await _flutterLedLightSdkPlugin
                                .setLightWithColorName(colorName);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                          child: Text(colorName),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final devices =
                        await _flutterLedLightSdkPlugin.getDevices();
                    setState(() {
                      this.devices = devices;
                    });
                    final rates = await _flutterLedLightSdkPlugin.getRates();
                    setState(() {
                      this.rates = rates;
                    });
                  },
                  child: const Text("Scan Devices & Rates"),
                ),
                const SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String?>(
                          isExpanded: true,
                          hint: const Text("Select Device"),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedDevice = value!;
                            });
                          },
                          items: devices
                              .map<DropdownMenuItem<String?>>((String? value) {
                            return DropdownMenuItem<String?>(
                              value: value,
                              child: Text(value ?? "Unknown"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<int>(
                          isExpanded: true,
                          hint: const Text("Select Rate"),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              selectedRate = value!;
                            });
                          },
                          items: rates.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (deviceOpened) {
                          // Device is open, so close it
                          final closed =
                              await _flutterLedLightSdkPlugin.closeDevice();
                          setState(() {
                            deviceOpened = !closed;
                          });
                        } else if (selectedDevice != null &&
                            selectedRate != null) {
                          // Device is closed, so open it
                          final opened =
                              await _flutterLedLightSdkPlugin.openDevice(
                            selectedDevice!,
                            selectedRate!,
                          );
                          setState(() {
                            deviceOpened = opened;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 60),
                      ),
                      child: Text(!deviceOpened ? "Open" : "Close"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
