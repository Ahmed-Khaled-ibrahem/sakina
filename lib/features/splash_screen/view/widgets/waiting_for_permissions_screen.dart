import 'package:flutter/material.dart';

class WaitingForPermissionsScreen extends StatelessWidget {
  const WaitingForPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Icon(Icons.settings, size: 100),
            Text("Waiting for permissions"),
          ],
        ),
      ),
    );
  }
}
