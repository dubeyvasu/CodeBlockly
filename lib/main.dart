import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  
   ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage()
    );
  }
}
 



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flexible vs Expanded Example in ListView")),
      body: ListView(
        children: [
          // Using Flexible inside ListView
          Row(
            children: [
              Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
              const Flexible(
                child: Card(
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Flexible content with text that might expand"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Using Expanded inside ListView
          Row(
            children: [
              Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
              const Expanded(
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Expanded content that fills the space"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Another example with Flexible
          Row(
            children: [
              Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
              const Flexible(
                
                child: Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Flexible content with flex 2"),
                  ),
                ),
              ),
              const Flexible(
                
                child: Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Flexible content with flex 1"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Another example with Expanded
          Row(
            children: [
              Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
              const Expanded(
               
                child: Card(
                  color: Colors.cyan,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Expanded content with flex 2"),
                  ),
                ),
              ),
              const Expanded(
                
                child: Card(
                  color: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Expanded content with flex 1"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


