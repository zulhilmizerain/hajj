import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const String googleApiKey =
    'AIzaSyDFOEW8xGpIPEtIGJ1PLfxdySe63hh2zpc'; // Replace if needed

class HotelMapPage extends StatefulWidget {
  @override
  _HotelMapPageState createState() => _HotelMapPageState();
}

class _HotelMapPageState extends State<HotelMapPage> {
  LatLng? _currentLocation;
  LatLng? _hotelLocation;
  String hotelAddress = 'Hotel anda';

  String? distanceText;
  String? durationText;

  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final position = await Geolocator.getLastKnownPosition() ??
        await Geolocator.getCurrentPosition();

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        final geo = data['hotel'];
        final latLng = LatLng(geo.latitude, geo.longitude);

        setState(() {
          _hotelLocation = latLng;
          hotelAddress = data['hotelAddress'] ?? 'Hotel anda';
        });

        _getDistanceAndDuration(
            position.latitude, position.longitude, geo.latitude, geo.longitude);
        _getDirections(
            _currentLocation!, _hotelLocation!); // ✅ This draws the route
      }
    }
  }

  Future<void> _getDistanceAndDuration(double originLat, double originLng,
      double destLat, double destLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&mode=driving&key=$googleApiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['routes'].isNotEmpty) {
      final leg = data['routes'][0]['legs'][0];
      setState(() {
        distanceText = leg['distance']['text'];
        durationText = leg['duration']['text'];
      });
    }
  }

  Future<void> _showNavigationOptions() async {
    if (_currentLocation == null || _hotelLocation == null) return;

    final lat = _hotelLocation!.latitude;
    final lng = _hotelLocation!.longitude;

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Google Maps'),
              onTap: () async {
                final url = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=$lat,$lng&travelmode=driving');
                if (await canLaunchUrl(url)) await launchUrl(url);
                Navigator.pop(context);
              },
            ),
            if (Theme.of(context).platform == TargetPlatform.iOS)
              ListTile(
                leading: Icon(Icons.map_outlined),
                title: Text('Apple Maps'),
                onTap: () async {
                  final url = Uri.parse(
                      'http://maps.apple.com/?daddr=$lat,$lng&dirflg=w');
                  if (await canLaunchUrl(url)) await launchUrl(url);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Waze'),
              onTap: () async {
                final url =
                    Uri.parse('https://waze.com/ul?ll=$lat,$lng&navigate=yes');
                if (await canLaunchUrl(url)) await launchUrl(url);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      _polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            width: 8,
            color: Colors.blue,
            points: _polylineCoordinates,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lokasi Hotel')),
      body: (_currentLocation == null || _hotelLocation == null)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 19,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('hotel'),
                      position: _hotelLocation!,
                      infoWindow: InfoWindow(title: hotelAddress),
                    ),
                  },
                  myLocationEnabled: true,
                  polylines: _polylines,
                ),
                if (distanceText != null && durationText != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    // right: 80,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jarak: $distanceText'),
                          Text('Anggaran Masa: $durationText'),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 20,
                  left: 100,
                  right: 100,
                  child: ElevatedButton.icon(
                    onPressed: _showNavigationOptions,
                    icon: Icon(Icons.navigation),
                    label: Text('Mula Navigasi ke Hotel'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
