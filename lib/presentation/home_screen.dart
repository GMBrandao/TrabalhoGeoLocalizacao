import 'package:appgeolocalizacao/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

const double latUniara = -21.804798;
const double longUniara = -48.172262;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String Distancia(lat, long) {
  double mil = 1000.00;
  double distance =
      Geolocator.distanceBetween(latUniara, longUniara, lat, long);

  if (distance >= mil) {
    return '${distance.truncate() / mil} km';
  }

  return '${distance.truncate()} metros';
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _currentPosition;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Distância para a Uniara é de aproximadamente ${Distancia(_currentPosition!.latitude, _currentPosition!.longitude)}',
        ),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: _currentPosition,
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                //Adiciona um marcador ao mapa na posição atual do usuário.
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 80,
                      height: 80,
                      builder: (ctx) => const Icon(
                        Icons.location_history,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(latUniara, longUniara),
                      width: 80,
                      height: 80,
                      builder: (ctx) => const Icon(
                        Icons.location_on_rounded,
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
