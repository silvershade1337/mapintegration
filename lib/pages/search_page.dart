import 'package:flutter/material.dart';
import 'package:mapint/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapint/models/location.dart';
import 'package:mapint/widgets/locationcard.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchInputController = TextEditingController();
  
  bool preProcessQuery() {
    if (searchInputController.text.isNotEmpty) {
      RegExp coordinatesRegex = RegExp(r"(?<lat>\d+\.?\d*) *, *(?<lon>\d+\.?\d*)");
      RegExpMatch? match = coordinatesRegex.firstMatch(searchInputController.text);
      if (match != null) {
        double lat=double.parse(match.namedGroup("lat")!), lon=double.parse(match.namedGroup("lon")!);
        if (lat.abs() <= 90 && lon.abs() <= 180) {
          BlocProvider.of<AppBloc>(context).add(SelectLocation(Location(lat, lon), false));
          return false;
        }
      }
      return true;
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Search query cannot be empty")));
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is MapDisplayed) {
            Navigator.of(context).pushNamed("/map");
          }
        },
        buildWhen: (previous, current) {
          List<Type> buildWhenStates = [Loading, NominatimResultsFetched, NominatimSearch];
          return buildWhenStates.contains(current.runtimeType);
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: state is Initial? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(),
                if (state is Initial) const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Hey there,\n where would you like to explore today?",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: searchInputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)), 
                      contentPadding: const EdgeInsets.only(left: 15),
                      alignLabelWithHint: true,
                      hintText: "Search any address, city or coordinates", 
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton.filled(onPressed: () {
                          if (preProcessQuery()) BlocProvider.of<AppBloc>(context).add(NominatimSearch(searchInputController.text));
                        }, icon: const Icon(Icons.search, color: Colors.white), padding: const EdgeInsets.all(0), ),
                      ),
                    ),
                  ),
                ),
                if (state is Initial) Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AppBloc>(context).add(
                            LocateUser((message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))))
                          );
                        }, 
                        child: const Text("Your Location")
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (preProcessQuery()) BlocProvider.of<AppBloc>(context).add(InstantLocate(searchInputController.text));
                        }, 
                        child: const Text("Insta-Locate")
                      ),
                    ],
                  )
                ),
                if (state is Loading) const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
                if (state is NominatimResultsFetched) Expanded(
                  child: ListView(
                    children: [
                      if (state.results.isEmpty) const Center(
                        child: Text("Search did not yield any results"),
                      ),
                      ...state.results.map((location) => LocationCard(location: location, onPressed: () {
                        BlocProvider.of<AppBloc>(context).add(SelectLocation(location, false));
                      },))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
