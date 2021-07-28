


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void moveToGoogleMap(LatLng latLng)async
{
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
  if (await canLaunch(googleUrl)) {
await launch(googleUrl);
} else {
throw 'Could not open the map.';
}
}