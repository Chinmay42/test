import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/UtilClass.dart';

 LatLng mylatLng;
 String markerTitle;

class MapWidget extends StatefulWidget
{

 MapWidget(LatLng latLng,String mtitle)
 {
   mylatLng = latLng;
   markerTitle = mtitle;
 }
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
{
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static MarkerId markerId = MarkerId('Dummy Center');

  final Marker marker = Marker(
    markerId: markerId,
    position: mylatLng,
    infoWindow: InfoWindow(title: markerTitle, snippet: '*'),
    onTap: ()
    {
     moveToGoogleMap(mylatLng);
    },
  );

  _MapWidgetState();
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values)

    );
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: mylatLng,
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers[markerId] = marker;
  }
}
