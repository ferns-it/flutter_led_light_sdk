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

  Map<String, List<int>>? colorsMap;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    try {
      final devices = await _flutterLedLightSdkPlugin.getDevices();
      final rates = await _flutterLedLightSdkPlugin.getRates();
      final colors = await _flutterLedLightSdkPlugin.getColorsMap();
      final deviceMap = await _flutterLedLightSdkPlugin.resumeDevice();

      if (deviceMap == null) return;

      setState(() {
        this.devices = devices;
        this.rates = rates;
        colorsMap = colors;
        selectedDevice = deviceMap['dev'];
        selectedRate = deviceMap['rate'];
        deviceOpened = true;
      });
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  List<int?>? getRGBValues(String colorName) {
    return colorsMap?[colorName];
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
                const SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        final devices =
                            await _flutterLedLightSdkPlugin.getDevices();
                        setState(() {
                          this.devices = devices;
                        });
                        final rates =
                            await _flutterLedLightSdkPlugin.getRates();
                        setState(() {
                          this.rates = rates;
                        });
                      },
                      child: const Text("Scan Devices & Rates"),
                    ),
                    const SizedBox(width: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _flutterLedLightSdkPlugin.startLightCrazyMode();
                      },
                      child: const Text("Start Crazy Mode"),
                    ),
                    const SizedBox(width: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _flutterLedLightSdkPlugin.stopLightCrazyMode();
                      },
                      child: const Text("Stop Crazy Mode"),
                    ),
                    const SizedBox(width: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _flutterLedLightSdkPlugin.startLightLiveMode();
                      },
                      child: const Text("Start Live Mode"),
                    ),
                    const SizedBox(width: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _flutterLedLightSdkPlugin.stopLightLiveMode();
                      },
                      child: const Text("Stop Live Mode"),
                    ),
                    const SizedBox(width: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _flutterLedLightSdkPlugin.setLightWithRGB(
                          30,
                          215,
                          96,
                        );
                      },
                      child: const Text("Set Custom Color"),
                    ),
                  ],
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
                const SizedBox(height: 40.0),
                Expanded(
                  child: Wrap(
                    spacing:
                        8.0, // Adjust the spacing between buttons as needed
                    runSpacing: 8.0, // Adjust the run spacing as needed
                    children: List.generate(
                      colorsMap?.length ?? 0,
                      (index) {
                        final colorName = colorsMap?.keys.elementAt(index);
                        final colors = colorsMap?[colorName];
                        if (colorName == null ||
                            colorsMap == null ||
                            colors == null) {
                          return const SizedBox();
                        }

                        final rgbColor = Color.fromRGBO(
                          colors[0],
                          colors[1],
                          colors[2],
                          1,
                        );
                        return InkWell(
                          onTap: () async {
                            await _flutterLedLightSdkPlugin
                                .setLightWithColorName(
                              colorName,
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: rgbColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                                child: Text(
                              colorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
