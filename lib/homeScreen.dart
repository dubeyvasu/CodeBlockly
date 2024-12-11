import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code to Hardware')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/device-connection'),
              child: const Text('Connect Device'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/code-editor'),
              child: const Text('Code Editor'),
            ),
          ],
        ),
      ),
    );
  }
}
