part of 'app_bloc.dart';

@immutable
sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class Initial extends AppState {
  const Initial();

  @override
  List<Object> get props => [];
}

final class Loading extends AppState {
  const Loading();

  @override
  List<Object> get props => [];
}

final class ResultsLoading extends AppState {
  const ResultsLoading();

  @override
  List<Object> get props => [];
}


final class NominatimResultsFetched extends AppState {
  final List<Location> results;

  const NominatimResultsFetched(this.results);
}

final class MapDisplayed extends AppState {
  final Location location;
  final bool isUserLocation;

  const MapDisplayed(this.location, this.isUserLocation);

  @override
  List<Object> get props => [location, isUserLocation];
}
