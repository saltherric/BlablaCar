import 'package:flutter/material.dart';

import '../../../../models/ride/locations.dart';
import '../../../../models/ride_pref/ride_pref.dart';
import '../../../../utils/date_time_util.dart';
import '../../../theme/theme.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/inputs/bla_location_picker.dart';

///
/// A Ride Preference Form is a view to select:
///   - A departure location
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

    final RidePref? init = widget.initRidePref;

    if (init != null) {
      departure = init.departure;
      arrival = init.arrival;
      departureDate = init.departureDate;
      requestedSeats = init.requestedSeats;
    } else {
      departureDate = DateTime.now(); // Defaults to now
      requestedSeats = 1; // Default: 1 seat
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
      final Location? tmp = departure;
      departure = arrival;
      arrival = tmp;
    });
  }

  void submit() {
    if (!isValid) return;

    final RidePref pref = RidePref(
      departure: departure!,
      departureDate: departureDate!,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );

    widget.onSubmit(pref);
  }

  void onDeparturePressed() async {
    // 1 - Open teacher's location picker
    final Location? selected = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (_) => BlaLocationPicker(initLocation: departure),
      ),
    );

    // 2 - Update the form if needed
    if (selected != null) {
      setState(() {
        departure = selected;
      });
    }
  }

  void onArrivalPressed() async {
    // 1 - Open teacher's location picker
    final Location? selected = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (_) => BlaLocationPicker(initLocation: arrival),
      ),
    );

    // 2 - Update the form if needed
    if (selected != null) {
      setState(() {
        arrival = selected;
      });
    }
  }

  void pickDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => departureDate = picked);
    }
  }

  void pickSeats() async {
    int temp = requestedSeats;

    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Select seats"),
          content: StatefulBuilder(
            builder:
                (BuildContext ctx, void Function(void Function()) setLocal) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: temp > 1
                            ? () => setLocal(() => temp--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text("$temp", style: BlaTextStyles.heading),
                      IconButton(
                        onPressed: temp < 8
                            ? () => setLocal(() => temp++)
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  );
                },
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

    if (picked != null) {
      setState(() => requestedSeats = picked);
    }
  }

  Widget inputTile({
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
            value: departure?.name ?? "Leaving from",
            icon: Icons.trip_origin,
            onTap: onDeparturePressed,
            trailing: IconButton(
              onPressed: switchLocations,
              icon: Icon(Icons.swap_vert, color: BlaColors.iconNormal),
            ),
          ),
          const SizedBox(height: BlaSpacings.s),
          inputTile(
            value: arrival?.name ?? "Going to",
            icon: Icons.place,
            onTap: onArrivalPressed,
          ),
          const SizedBox(height: BlaSpacings.s),
          inputTile(
            value: departureDate == null
                ? "Select date"
                : DateTimeUtils.formatDateTime(departureDate!),
            icon: Icons.calendar_month,
            onTap: pickDate,
          ),
          const SizedBox(height: BlaSpacings.s),
          inputTile(
            value: "$requestedSeats",
            icon: Icons.person,
            onTap: pickSeats,
          ),
          const SizedBox(height: BlaSpacings.l),
          Opacity(
            opacity: isValid ? 1 : 0.5,
            child: BlaButton(
              label: "Search",
              onPressed: isValid ? submit : null,
            ),
          ),
        ],
      ),
    );
  }
}
