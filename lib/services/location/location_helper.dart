import 'dart:developer';

import 'package:location/location.dart';

class LocationHelper {
  double? latitude;
  double? longitude;
  bool isDenied = true;

  Future<void> getCurrentLocation() async {
    try {
      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          isDenied = true;
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          isDenied = true;
          return;
        }
      }
      _locationData = await location.getLocation();
      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
      log("latitude:$latitude long:$longitude");
      isDenied = false;
    } catch (e) {
      isDenied = true;
      print(e);
    }
  }
}
