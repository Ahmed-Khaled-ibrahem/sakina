import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current bottom navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);