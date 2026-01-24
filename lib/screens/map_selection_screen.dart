
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  final MapController _mapController = MapController();
  LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default to SF
  LatLng? _currentPosition;
  bool _isLoading = true;
  String _address = "Fetching address...";
  Placemark? _placemark;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng userLatLong = LatLng(position.latitude, position.longitude);
      setState(() {
        _initialPosition = userLatLong;
        _currentPosition = _initialPosition;
        _isLoading = false;
      });
      _getAddressFromLatLng(userLatLong);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "";
        
        // Build address string
        if (place.street != null && place.street!.isNotEmpty) address += "${place.street}, ";
        if (place.subLocality != null && place.subLocality!.isNotEmpty) address += "${place.subLocality}, ";
        if (place.locality != null && place.locality!.isNotEmpty) address += "${place.locality}";
        
        if (address.endsWith(", ")) address = address.substring(0, address.length - 2);

        if (mounted) {
          setState(() {
            _placemark = place;
            _address = address.isEmpty ? "Unknown Location" : address;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = "Could not fetch address";
        });
      }
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
     if (hasGesture) {
        _currentPosition = camera.center;
        // Debounce the API call
        if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 600), () {
          if (_currentPosition != null) {
            _getAddressFromLatLng(_currentPosition!);
          }
        });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition,
              initialZoom: 15.0,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.meatbites_flutter',
              ),
              // We don't need a marker layer because the pin is fixed in the center UI
            ],
          ),
          
          // Center Location Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.0), // Adjust for pin tip
              child: Icon(Icons.location_pin, size: 50, color: AppColors.primary),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

           // Loading Overlay
           if (_isLoading)
            Container(
              color: Colors.white54,
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                 boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Text("Select Delivery Location", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                   const SizedBox(height: 12),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(LucideIcons.mapPin, color: AppColors.primary, size: 20)
                      ),
                      const SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                              _address,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                             ),
                             if (_placemark != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "${_placemark!.administrativeArea}, ${_placemark!.country}",
                                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                ),
                              )
                           ],
                         ),
                       ),
                    ],
                   ),
                   const SizedBox(height: 24),
                   SizedBox(
                     width: double.infinity,
                     child: ElevatedButton(
                      onPressed: () {
                         if (_placemark != null) {
                           Navigator.pop(context, {
                             'address': _address,
                             'placemark': _placemark,
                             'lat': _currentPosition?.latitude,
                             'lng': _currentPosition?.longitude,
                           });
                         }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("Confirm Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     ),
                   )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
