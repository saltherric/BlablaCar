import 'package:flutter/material.dart';
import 'widgets/bla_button.dart';

class BlaButtonTestScreen extends StatelessWidget {
  const BlaButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BlaButton Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary Button
            BlaButton(
              label: "Primary Button",
              onPressed: () {
                print("Primary pressed");
              },
            ),

            const SizedBox(height: 16),

            // Secondary Button
            BlaButton(
              label: "Secondary Button",
              isPrimary: false,
              onPressed: () {
                print("Secondary pressed");
              },
            ),

            const SizedBox(height: 16),

            // With Icon
            BlaButton(
              label: "Search Ride",
              icon: Icons.search,
              onPressed: () {
                print("Search pressed");
              },
            ),

            const SizedBox(height: 16),

            // Secondary + Icon
            BlaButton(
              label: "Filter",
              isPrimary: false,
              icon: Icons.filter_list,
              onPressed: () {
                print("Filter pressed");
              },
            ),

            const SizedBox(height: 16),

            // Disabled Button
            BlaButton(
              label: "Disabled Button",
              isEnabled: false,
              onPressed: () {
                print("This should NOT print");
              },
            ),
          ],
        ),
      ),
    );
  }
}
