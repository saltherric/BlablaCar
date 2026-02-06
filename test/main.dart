import '../lib/services/rides_service.dart';
import '../lib/model/ride/locations.dart';
void main() {
  final rides = RidesService.filterBy(
    departure: Location(name: "Dijon", country: Country.france),
    seatRequested: 2,
  );

  print(rides.length); 
  print(rides);
}
