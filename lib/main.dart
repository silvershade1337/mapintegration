import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapint/bloc/app_bloc.dart';
import 'package:mapint/pages/map_page.dart';
import 'package:mapint/pages/search_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(http.Client()),
      child: MaterialApp(
        title: 'Map Integration',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color.fromARGB(255, 0, 255, 183)),
          useMaterial3: true,
        ),
        routes: {
          "/search": (context) => const SearchPage(),
          "/map": (context) => const MapPage()
        },
        initialRoute: "/search",
      ),
    );
  }
}
