import 'package:flutter/material.dart';
import 'widgets/bla_button.dart';
import '../../theme/theme.dart';

class BlaButtonTestScreen extends StatelessWidget {
  const BlaButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BlaButton Test")),
      body: Padding(
        padding: const EdgeInsets.all(BlaSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlaButton(
              label: "Primary Button",
              onPressed: () {
                print("Primary pressed");
              },
            ),

            const SizedBox(height: BlaSpacings.m),

            BlaButton(
              label: "Secondary Button",
              isPrimary: false,
              onPressed: () {
                print("Secondary pressed");
              },
            ),

            const SizedBox(height: BlaSpacings.m),

            BlaButton(
              label: "Search Ride",
              icon: Icons.search,
              onPressed: () {
                print("Search pressed");
              },
            ),

            const SizedBox(height: BlaSpacings.m),

            BlaButton(
              label: "Filter",
              isPrimary: false,
              icon: Icons.filter_list,
              onPressed: () {
                print("Filter pressed");
              },
            ),
          ],
        ),
      ),
    );
  }
}
