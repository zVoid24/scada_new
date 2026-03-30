import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';

class MonthChartData {
  MonthChartData(this.x, this.solar, this.reb, this.load, this.gen, this.ess);
  final double x;
  final double solar;
  final double reb;
  final double load;
  final double gen;
  final double ess;
}

class MonthlyChartCard extends StatelessWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    // Generate 31 days of mock data
    final List<MonthChartData> allData = List.generate(31, (i) {
      final double day = (i + 1).toDouble();
      return MonthChartData(
        day,
        20.0 + (i % 5) * 10,
        15.0 + (i % 3) * 12,
        30.0 + (i % 4) * 8,
        10.0 + (i % 6) * 5,
        25.0 + (i % 2) * 15,
      );
    });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.0),
      ),
      child: Column(
        children: [
          _buildHeader('This Month Solar Energy - kWh'),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 220,
              child: Obx(
                () => SfCartesianChart(
                  margin: EdgeInsets.zero,
                  plotAreaBorderWidth: 1,
                  plotAreaBorderColor: Colors.grey.shade300,
                  zoomPanBehavior: ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.longPress,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    tooltipSettings: const InteractiveTooltip(enable: true, format: 'series.name : point.y kWh'),
                  ),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    plotOffset: 25,
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    interval: 1,
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    // Show 15 days initially
                    initialVisibleMinimum: -0.8,
                    initialVisibleMaximum: 14.2,
                    labelPlacement: LabelPlacement.onTicks,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 70,
                    interval: 10,
                    majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    title: AxisTitle(
                      text: 'Power',
                      textStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  series: <CartesianSeries>[
                    if (controller.isVisible('Solar'))
                      ColumnSeries<MonthChartData, String>(
                        name: 'Solar',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x.toInt().toString(),
                        yValueMapper: (d, _) => d.solar,
                        color: const Color(0xFF00C7E5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('REB'))
                      ColumnSeries<MonthChartData, String>(
                        name: 'REB',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x.toInt().toString(),
                        yValueMapper: (d, _) => d.reb,
                        color: const Color(0xFFFF9F00),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Load'))
                      ColumnSeries<MonthChartData, String>(
                        name: 'Load',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x.toInt().toString(),
                        yValueMapper: (d, _) => d.load,
                        color: const Color(0xFFD300C5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Generator'))
                      ColumnSeries<MonthChartData, String>(
                        name: 'Generator',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x.toInt().toString(),
                        yValueMapper: (d, _) => d.gen,
                        color: const Color(0xFF0091FF),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('ESS'))
                      ColumnSeries<MonthChartData, String>(
                        name: 'ESS',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x.toInt().toString(),
                        yValueMapper: (d, _) => d.ess,
                        color: const Color(0xFF7ED321),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12), // Replaced pagination with simple padding
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
            decoration: BoxDecoration(color: const Color(0xFFE6F1FF), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.bar_chart, color: Color(0xFF6E87A8), size: 18),
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
