import 'package:flutter/material.dart';

import '../widgets/chart_card.dart';
import '../widgets/component_selector.dart';
import '../widgets/energy_info_card.dart';
import '../widgets/live_energy_card.dart';
import '../widgets/monthly_chart_card.dart';
import '../widgets/yearly_chart_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


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
            const ComponentSelector(),
            const LiveEnergyCard(),
            const EnergyInfoCard(),



            const ChartCard(),
            const MonthlyChartCard(),
            const YearlyChartCard(),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }

}
