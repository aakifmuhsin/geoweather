import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      throw Exception('Failed to get current position: $e');
    }
  }

  Stream<Position> getPositionStream() {
    const locationOptions = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    return Geolocator.getPositionStream(locationSettings: locationOptions);
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
