import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalContainer = ProviderContainer();

/// This provider will store a timestamp or counter to force UI refresh.
final refreshProvider = StateProvider<int>((ref) => 0);