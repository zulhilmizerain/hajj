import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

const String googleApiKey = 'AIzaSyDFOEW8xGpIPEtIGJ1PLfxdySe63hh2zpc';
final places = GoogleMapsPlaces(apiKey: googleApiKey);

class HotelMapPickerPage extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  HotelMapPickerPage({required this.onLocationPicked});

  @override
  _HotelMapPickerPageState createState() => _HotelMapPickerPageState();
}

class _HotelMapPickerPageState extends State<HotelMapPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;
  LatLng? _currentPosition;
  String _pickedAddress = 'Hotel anda';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Akses lokasi disekat secara kekal.")),
        );
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Perkhidmatan lokasi tidak diaktifkan.")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Location error: $e");
    }
  }

  Future<void> _onTap(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      _pickedAddress = 'Hotel anda'; // fallback
    });

    final name = await _getPlaceNameFromLatLng(position);

    setState(() {
      _pickedAddress = name;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 17));
  }

  Future<String> _getPlaceNameFromLatLng(LatLng location) async {
    final response = await places.searchNearbyWithRadius(
      Location(lat: location.latitude, lng: location.longitude),
      50, // meters
      type: "establishment",
    );
    if (response.results.isNotEmpty) {
      return response.results.first.name;
    }
    return 'Hotel anda';
  }

  Future<List<Prediction>> _searchPlaces(String query) async {
    final response = await places
        .autocomplete(query, language: "ms", types: ["establishment"]);
    return response.predictions;
  }

  Future<void> _selectPlace(String placeId) async {
    final detail = await places.getDetailsByPlaceId(placeId);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final location = LatLng(lat, lng);

    setState(() {
      _pickedLocation = location;
      _pickedAddress = detail.result.name;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 17));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Lokasi Hotel")),
      body: Stack(
        children: [
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _onTap,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16,
                  ),
                  markers: _pickedLocation != null
                      ? {
                          Marker(
                            markerId: MarkerId("picked"),
                            position: _pickedLocation!,
                          )
                        }
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TypeAheadField<Prediction>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari nama hotel...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              suggestionsCallback: _searchPlaces,
              itemBuilder: (context, Prediction suggestion) {
                return ListTile(
                  title: Text(suggestion.description ?? ""),
                );
              },
              onSuggestionSelected: (Prediction suggestion) {
                _selectPlace(suggestion.placeId!);
                _searchController.clear();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _pickedLocation != null
          ? Stack(
              children: [
                Positioned(
                  bottom: 20,
                  left: 200,
                  right: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, {
                        'location': _pickedLocation,
                        'address': _pickedAddress,
                      });
                    },
                    icon: Icon(Icons.check),
                    label: Text("Pilih Lokasi Ini"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
