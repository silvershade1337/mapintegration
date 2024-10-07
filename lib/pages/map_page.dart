import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapint/bloc/app_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();
  bool topological = false;
  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AppBloc, AppState>(  
      builder: (context, state) {
        if (state is MapDisplayed) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              BlocProvider.of<AppBloc>(context).add(GoToInitial());
              return false;
            },
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(state.location.latitude, state.location.longitude),
                          initialZoom: 16,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:topological? 'https://a.tile.opentopomap.org/{z}/{x}/{y}.png' : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                            MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(state.location.latitude, state.location.longitude), 
                                child: state.isUserLocation? const Icon(Icons.my_location, color: Colors.lightBlue, size: 30) :  const Icon(Icons.location_on, color: Colors.red, size: 30),
                                rotate: true
                              )
                            ]
                          ),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    topological = !topological;
                  });
                },
                tooltip: 'Toggle Map Type',
                child: Icon(topological? Icons.landscape: Icons.map),
              ) 
            ),
          );
        }
        else {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }
      },
    );
  }
}
