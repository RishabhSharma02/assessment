import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyA5IWnkQKUXaz_7vecOut8VVaXewrkw50A";
  LatLng? currPos;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async => await getPos().then((value) =>  _getPolyline()));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: currPos == null
          ? const CircularProgressIndicator()
          : GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: currPos!,
          zoom: 17,
        ),
        markers: {
          Marker(markerId: const MarkerId("Currpos"), position: currPos!,infoWindow: const InfoWindow(title: "Source")),
          const Marker(markerId: MarkerId("Currpos"), position: LatLng(23.6889, 86.9661),infoWindow: InfoWindow(title: "Destination")),
        },
        polylines:Set<Polyline>.of(polylines.values),

      ),
    );
  }

  Future<void> getPos() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle case when location permission is denied
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle case when location permission is permanently denied
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();

    setState(() {
      currPos = LatLng(pos.latitude, pos.longitude);
      polylineCoordinates.add(currPos!); // Add current position to polyline coordinates
    });
  }
  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates,width: 7);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(currPos!.latitude, currPos!.longitude),
        const PointLatLng(23.6889, 86.9661),
        travelMode: TravelMode.driving,
       );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }
}
