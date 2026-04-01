import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';
import '../services/chart_download_service.dart';

class MonthChartData {
  MonthChartData(this.x, this.solar, this.grid, this.load, this.gen, this.ess);
  final DateTime x;
  final double solar;
  final double grid;
  final double load;
  final double gen;
  final double ess;
}

class MonthlyChartCard extends StatelessWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    // Generate days of mock data for the current month
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final List<MonthChartData> allData = List.generate(daysInMonth, (i) {
      final DateTime date = DateTime(now.year, now.month, i + 1);
      return MonthChartData(
        date,
        20.0 + (i % 5) * 10,
        15.0 + (i % 3) * 12, // grid
        30.0 + (i % 4) * 8,
        10.0 + (i % 6) * 5,
        25.0 + (i % 2) * 15,
      );
    });

    // Build download rows from allData
    final List<ChartRowData> downloadRows = allData
        .map((d) => ChartRowData(dateTime: d.x, solar: d.solar, grid: d.grid, load: d.load, generator: d.gen, ess: d.ess))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader('This Month Solar Energy - kWh', context, downloadRows),
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
                    // tooltipSettings: const InteractiveTooltip(enable: true, format: 'series.name : point.y kWh'),
                  ),
                  primaryXAxis: DateTimeCategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    interval: 1,
                    intervalType: DateTimeIntervalType.days,
                    // Set initial view to show 15 days (1-15 or 16-end) based on today's date.
                    initialVisibleMinimum: now.day <= 15
                        ? DateTime(now.year, now.month, 1)
                        : DateTime(now.year, now.month, 16),
                    initialVisibleMaximum: now.day <= 15
                        ? DateTime(now.year, now.month, 15)
                        : DateTime(now.year, now.month, daysInMonth),
                    labelPlacement: LabelPlacement.betweenTicks,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    axisLabelFormatter: (AxisLabelRenderDetails details) {
                      // For DateTimeCategoryAxis, details.value is the index of the data point.
                      // Since we have 31 days starting from 1, index + 1 gives us the day number.
                      return ChartAxisLabel((details.value.toInt() + 1).toString(), details.textStyle);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 70,
                    interval: 10,
                    majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  series: <CartesianSeries>[
                    if (controller.isVisible('Solar'))
                      ColumnSeries<MonthChartData, DateTime>(
                        name: 'Solar',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.solar,
                        color: const Color(0xFF00C7E5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Grid'))
                      ColumnSeries<MonthChartData, DateTime>(
                        name: 'Grid',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.grid,
                        color: const Color(0xFFFF9F00),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Load'))
                      ColumnSeries<MonthChartData, DateTime>(
                        name: 'Load',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.load,
                        color: const Color(0xFFD300C5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Generator'))
                      ColumnSeries<MonthChartData, DateTime>(
                        name: 'Generator',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.gen,
                        color: const Color(0xFF0091FF),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('ESS'))
                      ColumnSeries<MonthChartData, DateTime>(
                        name: 'ESS',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.x,
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

  Widget _buildHeader(String title, BuildContext context, List<ChartRowData> rows) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFE6F1FF), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.bar_chart, color: Color(0xFF6E87A8), size: 18),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => ChartDownloadService.showDownloadDialog(
                context: context,
                chartTitle: 'Monthly Solar Energy',
                rows: rows,
                dateFormat: 'dd-MMM-yyyy',
                filePrefix: 'Monthly_SolarEnergy',
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDDE1E6)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.file_download_outlined, color: Color(0xFF9CA3AF), size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
