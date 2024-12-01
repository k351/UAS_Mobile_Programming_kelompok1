import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uas_flutter/utils/geocode_utills.dart'; // Assuming this contains your geocoding function

class MapView extends StatefulWidget {
  final String? address;

  const MapView({super.key, required this.address});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _coordinates;

  @override
  void initState() {
    super.initState();
    if (widget.address != null && widget.address!.isNotEmpty) {
      _fetchCoordinates(widget.address!);
    } else {
      _coordinates = LatLng(-6.2088, 106.8456);
    }
  }

  // Fetch coordinates using the geocoding function
  Future<void> _fetchCoordinates(String address) async {
    final coords = await getCoordinatesFromAddress(address);
    if (coords != null) {
      setState(() {
        _coordinates = LatLng(coords['latitude']!, coords['longitude']!);
      });
    } else {
      // Handle error if coordinates are not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to find the location')),
      );
      // Fallback to a default location (e.g., Jakarta)
      setState(() {
        _coordinates = LatLng(-6.2088, 106.8456); // Jakarta coordinates
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Lokasi"),
      ),
      body: _coordinates == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: _coordinates ??
                    LatLng(-6.2088, 106.8456), // Default to Jakarta if null
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _coordinates ??
                          LatLng(
                              -6.2088, 106.8456), // Default to Jakarta if null
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
