import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}

class ChartCard extends StatelessWidget {
  const ChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    final List<ChartData> solarData = [
      ChartData(0, 2),
      ChartData(4, 5),
      ChartData(8, 2.5),
      ChartData(12, 6.2),
      ChartData(16, 3.1),
      ChartData(20, 6.8),
      ChartData(24, 2.9),
    ];
    final List<ChartData> rebData = [
      ChartData(0, 3),
      ChartData(4, 3.5),
      ChartData(8, 5.5),
      ChartData(12, 3),
      ChartData(16, 5.5),
      ChartData(20, 2.5),
      ChartData(24, 6),
    ];
    final List<ChartData> loadData = [
      ChartData(0, 4.5),
      ChartData(4, 6.5),
      ChartData(8, 3.5),
      ChartData(12, 5.8),
      ChartData(16, 4.2),
      ChartData(20, 5.5),
      ChartData(24, 3.8),
    ];
    final List<ChartData> genData = [
      ChartData(0, 5.5),
      ChartData(4, 2.2),
      ChartData(8, 4.8),
      ChartData(12, 4.1),
      ChartData(16, 6.3),
      ChartData(20, 3.2),
      ChartData(24, 5.2),
    ];
    final List<ChartData> essData = [
      ChartData(0, 2.5),
      ChartData(4, 4.8),
      ChartData(8, 6.2),
      ChartData(12, 3.5),
      ChartData(16, 4.5),
      ChartData(20, 6.1),
      ChartData(24, 4.3),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.0),
      ),
      child: Column(
        children: [
          _buildHeader('This Day Power Trend -kW'),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 220,
              child: Obx(
                () => SfCartesianChart(
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    // tooltipSettings: const InteractiveTooltip(enable: true, format: 'series.name : point.y kw'),
                  ),
                  margin: EdgeInsets.zero,
                  plotAreaBorderWidth: 1,
                  plotAreaBorderColor: Colors.grey.shade300,
                  primaryXAxis: NumericAxis(
                    minimum: 0,
                    maximum: 24,
                    interval: 4,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    axisLabelFormatter: (AxisLabelRenderDetails details) {
                      final int hour = details.value.toInt();
                      final String formatted = '${hour.toString().padLeft(2, '0')}:00';
                      return ChartAxisLabel(formatted, details.textStyle);
                    },
                    majorGridLines: MajorGridLines(color: Colors.grey.shade200),
                    axisLine: const AxisLine(width: 1, color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                    title: AxisTitle(
                      text: 'Hour',
                      textStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 10,
                    interval: 2,
                    majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                    axisLine: const AxisLine(width: 1, color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                    title: AxisTitle(
                      text: 'Power',
                      textStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  series: <CartesianSeries>[
                    if (controller.isVisible('Solar'))
                      SplineSeries<ChartData, double>(
                        name: 'Solar',
                        dataSource: solarData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        color: const Color(0xFF00C7E5),
                        width: 2,
                      ),
                    if (controller.isVisible('REB'))
                      SplineSeries<ChartData, double>(
                        name: 'REB',
                        dataSource: rebData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        color: const Color(0xFFFF9F00),
                        width: 2,
                      ),
                    if (controller.isVisible('Load'))
                      SplineSeries<ChartData, double>(
                        name: 'Load',
                        dataSource: loadData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        color: const Color(0xFFD300C5),
                        width: 2,
                      ),
                    if (controller.isVisible('Generator'))
                      SplineSeries<ChartData, double>(
                        name: 'Generator',
                        dataSource: genData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        color: const Color(0xFF0091FF),
                        width: 2,
                      ),
                    if (controller.isVisible('ESS'))
                      SplineSeries<ChartData, double>(
                        name: 'ESS',
                        dataSource: essData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        color: const Color(0xFF7ED321),
                        width: 2,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: const Color(0xFFEBF3FC), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.show_chart, color: Color(0xFF0091FF), size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDE1E6)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.file_download_outlined, color: Color(0xFF9CA3AF), size: 18),
          ),
        ],
      ),
    );
  }
}
