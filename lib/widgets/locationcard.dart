import 'package:flutter/material.dart';
import 'package:mapint/models/location.dart';


class LocationCard extends StatelessWidget {
  final Location location;
  final void Function() onPressed;
  const LocationCard({super.key, required this.location, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.name!, style: const TextStyle(color: Colors.white, fontSize: 20),),
                Text(location.displayName!, style: const TextStyle(color: Colors.white70),),
                Text("${location.longitude}, ${location.latitude}")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
