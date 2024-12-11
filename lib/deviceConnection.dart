import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class BlocklySpeechToText extends StatefulWidget {
  @override
  _BlocklySpeechToTextState createState() => _BlocklySpeechToTextState();
}

class _BlocklySpeechToTextState extends State<BlocklySpeechToText> {
  late InAppWebViewController webViewController;
  late FlutterSoundRecorder recorder;
  String recordedFilePath = "";
  bool isRecorderInitialized = false;
  String transcriptionResult = '';  // Added to store transcription result

  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    _initializeRecorder();
    String testFilePath = "assets/blockly/test_record.wav";
   Future<String> a=sendAudioToAPI(filePath: testFilePath);
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await recorder.openRecorder();
    Directory tempDir = await getTemporaryDirectory();
    recordedFilePath = "${tempDir.path}/speech.wav";
    isRecorderInitialized = true;
    if (mounted) setState(() {});
  }

  Future<String> recordAudio() async {
    if (!isRecorderInitialized) {
      return "Error: Recorder not initialized";
    }

    try {
      await recorder.startRecorder(
        toFile: recordedFilePath,
        codec: Codec.pcm16WAV,
      );
      return "Recording started...";
    } catch (e) {
      return "Error starting recording: $e";
    }
  }

  Future<String> stopRecording() async {
    if (!isRecorderInitialized) {
      return "Error: Recorder not initialized";
    }

    try {
      await recorder.stopRecorder();
      return "Recording stopped. File saved at $recordedFilePath";
    } catch (e) {
      return "Error stopping recording: $e";
    }
  }

  Future<String> sendAudioToAPI({String? filePath}) async {
  try {
    // Step 1: Log the received filePath or fallback to recordedFilePath
    String fileToSend = filePath ?? recordedFilePath;
    print("Using audio file: $fileToSend");

    // Step 2: If filePath points to an asset (start with 'assets/'), load it as bytes
    File? audioFile;

    if (fileToSend.startsWith('assets/')) {
      // Load the audio file from assets
      ByteData byteData = await rootBundle.load(fileToSend);
      List<int> bytes = byteData.buffer.asUint8List();
      audioFile = null; // No need for an actual file on disk
      print("Audio file loaded from assets: $fileToSend");

      // Step 3: Prepare the multipart request and send the file as bytes
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.5:5000/transcribe"),
      );

      // Use the byte array for the asset file
      request.files.add(http.MultipartFile.fromBytes(
        'audio', 
        bytes, 
        filename: "test_record.wav",  // You can set a custom filename here
      ));
      print("Audio file added to request from assets");

      // Step 4: Send the request and await the response
      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );
      print("Request sent. Server response status code: ${response.statusCode}");

      // Step 5: Check the response status
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print("Response data received: $responseData");

        // Step 6: Parse the transcription from the response
        final transcription = jsonDecode(responseData)['transcription'];
        print("Transcription received from server: $transcription");

        // Step 7: Update the UI with the transcription result
        setState(() {
          transcriptionResult = transcription;
        });
        return "Transcription: $transcription"; // Return the result for logging
      } else {
        print("Error: Server returned status code ${response.statusCode}");
        return "Error: Server returned status code ${response.statusCode}";
      }
    } else {
      // If the filePath is not an asset, it should be a normal file on the device.
      audioFile = File(fileToSend);
      if (!audioFile.existsSync()) {
        print("Error: Audio file does not exist at path $fileToSend");
        return "Error: No audio file found!";
      }
      print("Audio file found at path $fileToSend");

      // Prepare the multipart request for the file located on the device
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("http://127.0.0.1:5000/transcribe"),
      );

      // Use the file located on the device
      request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
      print("Audio file added to request from device");

      // Send the request and handle the response...
      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print("Response data received: $responseData");

        // Parse and return transcription...
        final transcription = jsonDecode(responseData)['transcription'];
        setState(() {
          transcriptionResult = transcription;
        });
        return "Transcription: $transcription";
      } else {
        print("Error: Server returned status code ${response.statusCode}");
        return "Error: Server returned status code ${response.statusCode}";
      }
    }
  } catch (e) {
    print("Error occurred while sending audio to API: $e");
    return "Error: $e";
  }
}

  void displayText(String text) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Update this function to load the HTML content correctly from assets
  Future<String> _loadLocalHtml() async {
    try {
      String content = await rootBundle.loadString('assets/blockly/index52.html');
      return content;
    } catch (e) {
      print("Error loading HTML: $e");
      throw Exception('Failed to load HTML content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blockly Speech-to-Text"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Column(
          children: [
            // Display the transcription result here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                transcriptionResult.isEmpty ? 'Transcription will appear here.' : transcriptionResult,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // WebView with Blockly and interaction
            Expanded(
              child: FutureBuilder<String>(
                future: _loadLocalHtml(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  String htmlContent = snapshot.data ?? '';

                  return InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri("data:text/html;base64,${base64Encode(utf8.encode(htmlContent))}"),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                      webViewController.addJavaScriptHandler(
                        handlerName: "runCode",
                        callback: (args) async {
                          if (args.isEmpty) return;
                          String code = args[0].toString();

                          if (code.contains("recordAudio()")) {
                            displayText(await recordAudio());
                          } else if (code.contains("stopRecording()")) {
                            displayText(await stopRecording());
                          } else if (code.contains("sendAudioToAPI()")) {
                            // Trigger sending the audio and update the UI
                            displayText(await sendAudioToAPI()); // Using default recording
                          } else if (code.contains("sendAudioFromFile()")) {
                            // Call the sendAudioToAPI method with a predefined file for testing
                            String testFilePath = "assets/blockly/test_record.wav";  // Set your audio file path here
                            displayText(await sendAudioToAPI(filePath: testFilePath));
                          }
                        },
                      );
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print("Console message: ${consoleMessage.message}");
                    },
                    onLoadError: (controller, url, code, message) {
                      print("WebView load error: $message");
                    },
                    onLoadStop: (controller, url) {
                      print("WebView loaded successfully");
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

  @override
  void dispose() {
    if (isRecorderInitialized) {
      recorder.closeRecorder();
    }
    super.dispose();
  }
}
