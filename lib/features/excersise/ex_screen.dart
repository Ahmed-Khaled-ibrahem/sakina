import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExScreen extends ConsumerStatefulWidget {
  const ExScreen({super.key});

  @override
  ConsumerState createState() => _ExScreenState();
}

class _ExScreenState extends ConsumerState<ExScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('After salah Exercise')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              cardDesign(
                'assets/icons/ex/1.png',
                Color(0xffF8F9FD),
                'Plank Pose',
                '30-60 sec      3 reps',
              ),
              cardDesign(
                'assets/icons/ex/2.png',
                Color(0xffFFEABF),
                'Bridge Pose',
                '30-60 sec      3 reps',
              ),
              cardDesign(
                'assets/icons/ex/3.png',
                Color(0xffA9B0FF),
                'Child Pose',
                '30-60 sec      3 reps',
              ),
              cardDesign(
                'assets/icons/ex/4.png',
                Color(0xffF8F9FD),
                'Downward Facing Pose',
                '30-60 sec      3 reps',
              ),
              cardDesign(
                'assets/icons/ex/5.png',
                Color(0xffFFEABF),
                'Cobra Pose',
                '30-60 sec      3 reps',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardDesign(String path, Color color, String name, String description) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff2C2F41)
          : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Image.asset(path),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
