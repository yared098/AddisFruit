import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackMapPage extends StatefulWidget {
  const TrackMapPage({super.key});

  @override
  State<TrackMapPage> createState() => _TrackMapPageState();
}

class _TrackMapPageState extends State<TrackMapPage> {
  final MapController _mapController = MapController();

  LatLng? selectedPoint;
  String? selectedName;
  String? selectedDescription;
  double? distanceToUser;
  LatLng? userLocation;

  List<Map<String, dynamic>> savedMarkets = [];

  final List<Map<String, dynamic>> markerData = [
    {
      "position": LatLng(9.03, 38.74),
      "name": "Merkato Market",
      "description": "The largest open-air market in Africa.",
    },
    {
      "position": LatLng(9.01, 38.76),
      "name": "Shola Market",
      "description": "Famous for fresh produce and clothing.",
    },
    {
      "position": LatLng(9.04, 38.73),
      "name": "Bole Market",
      "description": "Trendy shops and cafes nearby.",
    },
    {
      "position": LatLng(9.02, 38.75),
      "name": "Piazza Market",
      "description": "Historic market in central Addis.",
    },
    {
      "position": LatLng(9.00, 38.74),
      "name": "Lebu Market",
      "description": "A busy spot for daily goods.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadSavedMarkets();
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lon = prefs.getDouble('longitude');

    if (lat != null && lon != null) {
      setState(() {
        userLocation = LatLng(lat, lon);
      });
    }
  }

  Future<void> _loadSavedMarkets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? marketsJson = prefs.getString('saved_markets');
    if (marketsJson != null) {
      final List<dynamic> list = jsonDecode(marketsJson);
      setState(() {
        savedMarkets = List<Map<String, dynamic>>.from(list);
      });
    }
  }

  Future<void> _toggleSaveMarket() async {
    if (selectedPoint == null || selectedName == null) return;

    final existingIndex = savedMarkets.indexWhere((market) =>
        market['latitude'] == selectedPoint!.latitude &&
        market['longitude'] == selectedPoint!.longitude);

    final prefs = await SharedPreferences.getInstance();

    if (existingIndex != -1) {
      // Market is already saved — remove it
      savedMarkets.removeAt(existingIndex);
      await prefs.setString('saved_markets', jsonEncode(savedMarkets));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Market unsaved')),
      // );
    } else {
      // Save new market
      final Map<String, dynamic> data = {
        'name': selectedName,
        'description': selectedDescription,
        'latitude': selectedPoint!.latitude,
        'longitude': selectedPoint!.longitude,
      };
      savedMarkets.add(data);
      await prefs.setString('saved_markets', jsonEncode(savedMarkets));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Market saved successfully')),
      // );
    }

    setState(() {});
  }

  bool _isSavedMarker(LatLng point) {
    return savedMarkets.any((market) =>
        market['latitude'] == point.latitude &&
        market['longitude'] == point.longitude);
  }

  Future<void> _getAndSaveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    final Distance distance = const Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final mapTileUrl = isDarkMode
        ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
        : 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png';

    final infoBoxColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final isSaved = selectedPoint != null && _isSavedMarker(selectedPoint!);

    return Scaffold(
       appBar: AppBar(
        title: const Text('Market Place'),
        backgroundColor: isDarkMode ? Colors.teal.shade700 : Colors.green,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(9.03, 38.74),
              initialZoom: 13,
              onTap: (_, __) {
                setState(() {
                  selectedPoint = null;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: mapTileUrl,
                userAgentPackageName: 'com.example.addisfruit',
              ),
              MarkerLayer(
                markers: markerData.map((data) {
                  final LatLng pos = data["position"];
                  final bool isSaved = _isSavedMarker(pos);
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: pos,
                    child: GestureDetector(
                      onTap: () {
                        double? dist;
                        if (userLocation != null) {
                          dist = _calculateDistance(userLocation!, pos);
                        }
                        setState(() {
                          selectedPoint = pos;
                          selectedName = data["name"];
                          selectedDescription = data["description"];
                          distanceToUser = dist;
                        });
                      },
                      child: Icon(
                        Icons.location_on,
                        color: isSaved
                            ? Colors.green
                            : isDarkMode
                                ? Colors.orangeAccent
                                : Colors.red,
                        size: 30,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Info Box
          if (selectedPoint != null)
            Positioned(
              bottom: userLocation == null ? 80 : 30,
              left: 20,
              right: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDarkMode ? Colors.white12 : Colors.black26,
                  ),
                ),
                color: infoBoxColor?.withOpacity(0.95),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedName ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.greenAccent
                                    : Colors.green,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: textColor),
                            onPressed: () {
                              setState(() {
                                selectedPoint = null;
                                selectedName = null;
                                selectedDescription = null;
                                distanceToUser = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedDescription ?? '',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      if (userLocation != null && distanceToUser != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Distance: ${distanceToUser!.toStringAsFixed(2)} km',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _toggleSaveMarket,
                          icon: Icon(isSaved ? Icons.delete : Icons.save),
                          label: Text(isSaved ? "Unsave" : "Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSaved ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Share Location Button
          if (userLocation == null)
            Positioned(
              bottom: 20,
              left: 80,
              right: 80,
              child: ElevatedButton.icon(
                onPressed: _getAndSaveLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Share My Location"),
              ),
            ),

          // Zoom Controls
          Positioned(
            top: 80,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  backgroundColor: Colors.green,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom + 1;
                    _mapController.move(
                      _mapController.camera.center,
                      zoom.clamp(1.0, 18.0),
                    );
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  backgroundColor: Colors.green,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom - 1;
                    _mapController.move(
                      _mapController.camera.center,
                      zoom.clamp(1.0, 18.0),
                    );
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
