import 'package:flutter/material.dart';

class PermissionsDeniedScreen extends StatelessWidget {
  const PermissionsDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.health_and_safety, size: 100),
                SizedBox(height: 20),
                Text(
                  'Bluetooth Permission is required to use this app',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
