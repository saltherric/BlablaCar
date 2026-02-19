import 'package:flutter/material.dart';

import 'package:blabla/models/ride/locations.dart';
import 'package:blabla/services/locations_service.dart';
import 'package:blabla/ui/theme/theme.dart';
import 'package:blabla/ui/widgets/display/bla_divider.dart';

class BlaLocationPicker extends StatefulWidget {
  const BlaLocationPicker({super.key, required this.initLocation});

  final Location? initLocation;

  @override
  State<BlaLocationPicker> createState() => _BlaLocationPickerState();
}

class _BlaLocationPickerState extends State<BlaLocationPicker> {
  String currentSearchText = "";

  @override
  void initState() {
    super.initState();

    // Initialize the search bar if any initial location
    if (widget.initLocation != null) {
      currentSearchText = widget.initLocation!.name;
    }
  }

  void onTap(Location location) {
    Navigator.pop<Location>(context, location);
  }

  void onBackTap() {
    Navigator.pop<Location>(context);
  }

  void onSearchChanged(String search) {
    setState(() {
      currentSearchText = search;
    });
  }

  List<Location> get filteredLocation {
    if (currentSearchText.length < 2) {
      return <Location>[];
    }

    final String query = currentSearchText.toUpperCase();

    return LocationsService.availableLocations
        .where(
          (Location location) => location.name.toUpperCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            LocationSearchBar(
              initSearch: currentSearchText,
              onBackTap: onBackTap,
              onSearchChanged: onSearchChanged,
            ),
            const SizedBox(height: BlaSpacings.m),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLocation.length,
                itemBuilder: (BuildContext context, int index) {
                  return LocationTile(
                    location: filteredLocation[index],
                    onTap: onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({
    super.key,
    required this.onBackTap,
    required this.onSearchChanged,
    required this.initSearch,
  });

  final String initSearch;
  final VoidCallback onBackTap;
  final ValueChanged<String> onSearchChanged;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initSearch;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get searchIsNotEmpty => _searchController.text.isNotEmpty;

  void onClearTap() {
    // 1 - Clear the text field
    _searchController.clear();

    // 2 - Notify the parent so the result list becomes empty
    widget.onSearchChanged("");

    // 3 - Rebuild to hide the close icon immediately
    setState(() {});
  }

  void onSearchTextChanged(String text) {
    // 1 - Notify the parent
    widget.onSearchChanged(text);

    // 2 - Rebuild to show/hide the close icon
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
        color: BlaColors.greyLight,
      ),
      child: Row(
        children: [
          // BACK ICON
          IconButton(
            onPressed: widget.onBackTap,
            icon: Icon(
              Icons.arrow_back_ios,
              color: BlaColors.iconLight,
              size: 16,
            ),
          ),

          // TEXT FIELD
          Expanded(
            child: TextField(
              focusNode: _focusNode, // Keep focus
              controller: _searchController,
              onChanged: onSearchTextChanged,
              style: BlaTextStyles.body.copyWith(color: BlaColors.textLight),
              decoration: const InputDecoration(
                hintText: "Any city, street...",
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),

          // CLOSE ICON
          if (searchIsNotEmpty)
            IconButton(
              onPressed: onClearTap,
              icon: Icon(Icons.close, color: BlaColors.iconLight, size: 16),
            ),
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, required this.onTap});

  final Location location;
  final ValueChanged<Location> onTap;

  String get title => location.name;
  String get subTitle => location.country.name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap(location),
          leading: Icon(Icons.history, color: BlaColors.iconLight),
          title: Text(title, style: BlaTextStyles.body),
          subtitle: Text(
            subTitle,
            style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: BlaColors.iconLight,
            size: 16,
          ),
        ),
        const BlaDivider(),
      ],
    );
  }
}
