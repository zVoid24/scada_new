import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chart_controller.dart';
import 'chart_card.dart';
import 'monthly_chart_card.dart';
import 'yearly_chart_card.dart';

class UnifiedChartSegment extends StatelessWidget {
  const UnifiedChartSegment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.2),
      ),
      child: Column(
        children: [
          const UnifiedLegend(),
          const SizedBox(height: 16),
          const ChartCard(),
          const MonthlyChartCard(),
          const YearlyChartCard(),
        ],
      ),
    );
  }
}

class UnifiedLegend extends StatelessWidget {
  const UnifiedLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChartController>();

    final List<Map<String, dynamic>> legendItems = [
      {'name': 'Solar', 'color': const Color(0xFF00C7E5)},
      {'name': 'REB', 'color': const Color(0xFFFF9F00)},
      {'name': 'Load', 'color': const Color(0xFFD300C5)},
      {'name': 'Generator', 'color': const Color(0xFF0091FF)},
      {'name': 'ESS', 'color': const Color(0xFF7ED321)},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 8,
      children: legendItems.map((item) => _buildLegendItem(item, controller)).toList(),
    );
  }

  Widget _buildLegendItem(Map<String, dynamic> item, ChartController controller) {
    final String name = item['name'];
    final Color color = item['color'];

    return GestureDetector(
      onTap: () => controller.toggleSeries(name),
      child: Obx(() {
        final bool isVisible = controller.isVisible(name);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isVisible ? color : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isVisible ? color : Colors.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
