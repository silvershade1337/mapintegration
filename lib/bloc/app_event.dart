part of 'app_bloc.dart';

@immutable
sealed class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GoToInitial extends AppEvent {
  @override
  List<Object> get props => [];
}


final class NominatimSearch extends AppEvent {
  final String query;

  NominatimSearch(this.query);

  @override
  List<Object> get props => [query];
}

final class InstantLocate extends AppEvent {
  final String query;

  InstantLocate(this.query);

  @override
  List<Object> get props => [query];
}

final class SelectLocation extends AppEvent {
  final Location location;
  final bool userLocation;
  

  SelectLocation(this.location, this.userLocation);

  @override
  List<Object> get props => [location, userLocation];
}


final class LocateUser extends AppEvent {
  final Function(String) displayError;
  
  LocateUser(this.displayError);

  @override
  List<Object> get props => [displayError];
}
