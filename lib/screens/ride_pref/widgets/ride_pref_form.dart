import 'package:flutter/material.dart';

import '../../../models/ride/locations.dart';
import '../../../models/ride_pref/ride_pref.dart';
import '../../../services/locations_service.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_time_util.dart';
import 'bla_button.dart';
import '../../location/location_picker_screen.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;
  final ValueChanged<RidePref> onSubmit;

  const RidePrefForm({super.key, this.initRidePref, required this.onSubmit});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  Location? arrival;
  DateTime? departureDate;
  int requestedSeats = 1;

  @override
  void initState() {
    super.initState();

    final init = widget.initRidePref;
    if (init != null) {
      departure = init.departure;
      arrival = init.arrival;
      departureDate = init.departureDate;
      requestedSeats = init.requestedSeats;
    } else {
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  bool get isValid =>
      departure != null &&
      arrival != null &&
      departure != arrival &&
      departureDate != null &&
      requestedSeats > 0;

  void switchLocations() {
    setState(() {
      final tmp = departure;
      departure = arrival;
      arrival = tmp;
    });
  }

  void submit() {
    if (!isValid) return;

    final pref = RidePref(
      departure: departure!,
      departureDate: departureDate!,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );

    widget.onSubmit(pref);
  }


  Future<void> _pickDeparture() async {
    final picked = await Navigator.push<Location>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );

    if (picked != null) setState(() => departure = picked);
  }


  Future<void> _pickArrival() async {
  final picked = await Navigator.push<Location>(
    context,
    MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
  );

  if (picked != null) setState(() => arrival = picked);
}


  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => departureDate = picked);
  }

  Future<void> pickSeats() async {
    int temp = requestedSeats;

    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Select seats"),
          content: StatefulBuilder(
            builder: (ctx, setLocal) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: temp > 1 ? () => setLocal(() => temp--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Text("$temp", style: BlaTextStyles.heading),
                IconButton(
                  onPressed: temp < 8 ? () => setLocal(() => temp++) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, temp),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    if (picked != null) setState(() => requestedSeats = picked);
  }

  Widget inputTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: BlaColors.white,
      borderRadius: BorderRadius.circular(BlaSpacings.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(BlaSpacings.m),
          decoration: BoxDecoration(
            border: Border.all(color: BlaColors.greyLight),
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
          ),
          child: Row(
            children: [
              Icon(icon, color: BlaColors.iconNormal),
              const SizedBox(width: BlaSpacings.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: BlaTextStyles.label.copyWith(
                        color: BlaColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: BlaTextStyles.body.copyWith(
                        color: BlaColors.textNormal,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null)
                Icon(Icons.chevron_right, color: BlaColors.iconLight),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BlaSpacings.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputTile(
            label: "From",
            value: departure?.name ?? "Select departure",
            icon: Icons.trip_origin,
            onTap: _pickDeparture,
          ),
          const SizedBox(height: BlaSpacings.s),

          inputTile(
            label: "To",
            value: arrival?.name ?? "Select arrival",
            icon: Icons.place,
            onTap: _pickArrival,
            trailing: IconButton(
              onPressed: switchLocations,
              icon: Icon(Icons.swap_vert, color: BlaColors.iconNormal),
            ),
          ),
          const SizedBox(height: BlaSpacings.s),

          inputTile(
            label: "Date",
            value: departureDate == null
                ? "Select date"
                : DateTimeUtils.formatDateTime(departureDate!),
            icon: Icons.calendar_month,
            onTap: pickDate,
          ),
          const SizedBox(height: BlaSpacings.s),

          inputTile(
            label: "Seats",
            value: "$requestedSeats",
            icon: Icons.person,
            onTap: pickSeats,
          ),
          const SizedBox(height: BlaSpacings.l),

          Opacity(
            opacity: isValid ? 1 : 0.5,
            child: BlaButton(
              label: "Search",
              icon: Icons.search,
              onPressed: isValid ? submit : () {},
            ),
          ),
        ],
      ),
    );
  }
}
