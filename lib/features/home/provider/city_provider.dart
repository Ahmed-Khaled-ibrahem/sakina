import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final locationProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<String>>(
      (ref) => LocationNotifier(),
    );

class LocationNotifier extends StateNotifier<AsyncValue<String>> {
  LocationNotifier() : super(const AsyncValue.loading()) {
    _getCity();
  }

  Future<void> _getCity() async {
    try {
      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = const AsyncValue.error("Permission denied", StackTrace.empty);
        return;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position);

      // Convert to placemark
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final country = placemarks.first.country ?? "Cairo";
      final city = placemarks.first.locality ?? "Cairo";
      state = AsyncValue.data("$city\n$country");
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
