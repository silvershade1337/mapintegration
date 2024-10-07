import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapint/models/location.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final http.Client httpClient;
  AppBloc(this.httpClient) : super(const Initial()) {
    on<GoToInitial>((event, emit) {
      emit(Initial());
    },);
    on<NominatimSearch>(_searchNominatim);
    on<InstantLocate>(_locateInstant);
    on<SelectLocation>(_selectLocation);
    on<LocateUser>(_locateUser);
  }
  
  _searchNominatim(NominatimSearch event, Emitter<AppState> emit) async {
    emit(const ResultsLoading());
    Uri uri = Uri.https("nominatim.openstreetmap.org", "search", {'q': event.query, 'format': 'json'});
    try {
      var resp = await httpClient.get(uri, headers: {"User-Agent": "mapint/1.0", "Accept": "*/*", "Accept-Encoding": "gzip, deflate, br"});
      if (resp.statusCode == 200) {
        List results = jsonDecode(resp.body);
        var resultLocations = results.map((e) => Location(double.parse(e["lat"]), double.parse(e["lon"]), displayName:e["display_name"], name:e["name"], type:e["type"]),);
        emit(NominatimResultsFetched(resultLocations.toList()));
      }
    } catch (e) {
      emit(const NominatimResultsFetched([]));
    }
  }

  _locateInstant(InstantLocate event, Emitter<AppState> emit) async {
    emit(const Loading());
    Uri uri = Uri.https("nominatim.openstreetmap.org", "search", {'q': event.query, 'format': 'json'});
    try {
      var resp = await httpClient.get(uri, headers: {"User-Agent": "mapint/1.0", "Accept": "*/*", "Accept-Encoding": "gzip, deflate, br"});
      if (resp.statusCode == 200) {
        List results = jsonDecode(resp.body);
        var resultLocations = results.map((e) => Location(double.parse(e["lat"]), double.parse(e["lon"]), displayName:e["display_name"], name:e["name"], type:e["type"]),);
        if(resultLocations.isNotEmpty) {
          emit(MapDisplayed(resultLocations.toList()[0], false));
        }
        else {
          emit(NominatimResultsFetched(resultLocations.toList()));
        }
      }
    } catch (e) {
      emit(const NominatimResultsFetched([]));
    }
  }

  _selectLocation(SelectLocation event, Emitter<AppState> emit) {
    emit(MapDisplayed(event.location, false));
  }

  _locateUser(LocateUser event, Emitter<AppState> emit) async {
    bool serviceEnabled;
    LocationPermission permission;
    emit(const Loading());


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      event.displayError('Location services are disabled.');
      emit(Initial());
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        event.displayError('Location permissions are denied');
        emit(Initial());
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      event.displayError('Location permissions are permanently denied, we cannot request permissions.');
      emit(Initial());
      return;
    } 

    Position userLocation = await Geolocator.getCurrentPosition();
    emit(MapDisplayed(Location(userLocation.latitude, userLocation.longitude, name:"User Location"), true)); 
  }
}
