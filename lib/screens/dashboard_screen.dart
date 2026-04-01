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
  late final String selectedComponent;

  @override
  void initState() {
    super.initState();
    // Get the selected component from arguments (default to 'Grid')
    selectedComponent = Get.arguments ?? 'Grid';

    // Initially, set only the selected component as visible in the chart legend.
    chartController.resetToSingle(selectedComponent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDF5), // Light blue-grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2040)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          selectedComponent,
          style: const TextStyle(color: Color(0xFF0F2040), fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: const Color(0xFFDDE1E6), width: 1.2),
              ),
              child: Column(
                children: [
                  ComponentSelector(initialComponentName: selectedComponent),
                  const LiveEnergyCard(),
                  const EnergyInfoCard(),
                  const SizedBox(height: 12)
                ],
              ),
            ),
            const UnifiedChartSegment(),
            // const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }
}
