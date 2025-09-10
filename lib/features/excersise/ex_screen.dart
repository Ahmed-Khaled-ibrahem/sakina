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
    return Center(
      child: Text('Ex Screen'),
    );
  }
}
