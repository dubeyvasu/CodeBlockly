
import 'package:wifi_iot/wifi_iot.dart';

void sendToDevice(String code) async {
  try {
    final success = await WiFiForIoTPlugin.connect(
      "Your_Device_WiFi_SSID",
      password: "password",
      security: NetworkSecurity.WPA,
    );
    if (success) {
      // Example: Send code via HTTP
      // Implement an HTTP request to send code to the device
      print("Code sent: $code");
    }
  } catch (e) {
    print("Error: $e");
  }
}
