import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_screen.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> components = [
      {'name': 'Solar', 'icon': Icons.solar_power, 'color': const Color(0xFF00C7E5)},
      {'name': 'Grid', 'icon': Icons.grid_view, 'color': const Color(0xFFFF9F00)},
      {'name': 'ESS', 'icon': Icons.battery_charging_full, 'color': const Color(0xFF7ED321)},
      {'name': 'Load', 'icon': Icons.electrical_services, 'color': const Color(0xFFD300C5)},
      {'name': 'Generator', 'icon': Icons.settings_input_component, 'color': const Color(0xFF0091FF)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6EDF5),
      appBar: AppBar(
        title: const Text('Select Component'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F2040),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a component to view specifically:',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: components.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = components[index];
                  return _buildComponentButton(
                    context,
                    item['name'],
                    item['icon'],
                    item['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentButton(BuildContext context, String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const DashboardScreen(), arguments: name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE1E6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2040),
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFDDE1E6), size: 16),
          ],
        ),
      ),
    );
  }
}
