// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class CodeEditorScreen extends StatefulWidget {
  const CodeEditorScreen({super.key});  

  @override
  State<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  late InAppWebViewController webViewController;

  @override
  void dispose() {
    super.dispose();
    webViewController.dispose(); // Clean up the WebView controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: _loadLocalHtml(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading HTML"));
                  }
        
                  String htmlContent = snapshot.data ?? '';
        
                  return InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri("data:text/html;base64,${base64Encode(utf8.encode(htmlContent))}"),
                    ),
                    initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    ),
                    
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      if (kDebugMode) {
                        print("Console: ${consoleMessage.message}");
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _loadLocalHtml() async {
    return await rootBundle.loadString('assets/blockly/index22.html'); // Load the local HTML file
  }




//  void _connectWiFi() async {
//   try {
//     // Check for location permission before scanning Wi-Fi networks
//     PermissionStatus locationPermission = await Permission.location.request();

//     if (!locationPermission.isGranted) {
//       // If location permission is not granted, show a message
//       print('Please grant location permission to scan for Wi-Fi networks.');
//       return;
//     }

//     // Get list of available Wi-Fi networks
//     List<dynamic> networks = await WiFiForIoTPlugin.loadWifiList();

//     // If no networks are found, show a message
//     if (networks.isEmpty) {
//       print('No Wi-Fi networks found.');
//       return;
//     }

//     // Show a list of available Wi-Fi networks
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Select a Wi-Fi Network"),
//           content: SizedBox(
//             height: 300,
//             width: 200,
//             child: ListView.builder(
//               itemCount: networks.length,
//               itemBuilder: (context, index) {
//                 var network = networks[index];
//                 return ListTile(
//                   title: Text(network.ssid),
//                   onTap: () async {
//                     Navigator.pop(context); // Close the dialog
//                     // Connect to the selected Wi-Fi network
//                     bool connected = await WiFiForIoTPlugin.connect(network.ssid);
//                     if (connected) {
//                       print('Connected to Wi-Fi: ${network.ssid}');
//                     } else {
//                       print('Failed to connect to Wi-Fi: ${network.ssid}');
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   } catch (e) {
//     print('Error scanning Wi-Fi networks: $e');
//   }
// }

  
}
