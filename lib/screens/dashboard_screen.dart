import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chart_controller.dart';
import '../widgets/component_selector.dart';
import '../widgets/energy_info_card.dart';
import '../widgets/live_energy_card.dart';
import '../widgets/unified_chart_segment.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Initialize the ChartController
  final ChartController chartController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDF5), // Light blue-grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2040)),
          onPressed: () {},
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Color(0xFF0F2040), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: const Color(0xFFDDE1E6), width: 1.2),
              ),
              child: const Column(
                children: [ComponentSelector(), LiveEnergyCard(), EnergyInfoCard(), SizedBox(height: 12)],
              ),
            ),
            const UnifiedChartSegment(),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }
}
