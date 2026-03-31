import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';
import '../services/chart_download_service.dart';

class YearChartData {
  YearChartData(this.month, this.solar, this.reb, this.load, this.gen, this.ess);
  final DateTime month;
  final double solar;
  final double reb;
  final double load;
  final double gen;
  final double ess;
}

class YearlyChartCard extends StatelessWidget {
  const YearlyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    final List<YearChartData> allData = [
      YearChartData(DateTime(2024, 1, 1), 15000, 12000, 25000, 8000, 18000),
      YearChartData(DateTime(2024, 2, 1), 18000, 14000, 22000, 9000, 16000),
      YearChartData(DateTime(2024, 3, 1), 25000, 18000, 20000, 12000, 22000),
      YearChartData(DateTime(2024, 4, 1), 65000, 45000, 55000, 30000, 40000),
      YearChartData(DateTime(2024, 5, 1), 115000, 85000, 95000, 60000, 75000),
      YearChartData(DateTime(2024, 6, 1), 90000, 70000, 80000, 50000, 65000),
      YearChartData(DateTime(2024, 7, 1), 95000, 75000, 85000, 55000, 70000),
      YearChartData(DateTime(2024, 8, 1), 100000, 80000, 90000, 60000, 75000),
      YearChartData(DateTime(2024, 9, 1), 85000, 65000, 75000, 45000, 60000),
      YearChartData(DateTime(2024, 10, 1), 70000, 55000, 65000, 35000, 50000),
      YearChartData(DateTime(2024, 11, 1), 40000, 30000, 45000, 20000, 35000),
      YearChartData(DateTime(2024, 12, 1), 20000, 15000, 30000, 10000, 25000),
    ];

    // Build download rows from allData
    final List<ChartRowData> downloadRows = allData.map((d) => ChartRowData(
      dateTime: d.month,
      solar: d.solar,
      reb: d.reb,
      load: d.load,
      generator: d.gen,
      ess: d.ess,
    )).toList();

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
          _buildHeader('This Yearly Solar Energy - kWh', context, downloadRows),
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
                  primaryXAxis: DateTimeCategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    initialVisibleMinimum: DateTime.now().month >= 7 ? DateTime(2024, 7, 1) : DateTime(2024, 1, 1),
                    initialVisibleMaximum: DateTime.now().month >= 7 ? DateTime(2024, 12, 1) : DateTime(2024, 6, 1),
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    labelPlacement: LabelPlacement.betweenTicks,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 1,
                    intervalType: DateTimeIntervalType.months,
                    axisLabelFormatter: (AxisLabelRenderDetails details) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      final int index = details.value.toInt();
                      if (index >= 0 && index < months.length) {
                        return ChartAxisLabel(months[index], details.textStyle);
                      }
                      return ChartAxisLabel('', details.textStyle);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 140000,
                    interval: 20000,
                    majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                    axisLabelFormatter: (args) {
                      final int val = args.value.toInt();
                      if (val >= 100000)
                        return ChartAxisLabel(
                          '${(val / 1000).toStringAsFixed(0)}k', // Keep consistent with monthly or stick to k
                          args.textStyle,
                        );
                      return ChartAxisLabel('${val ~/ 1000}k', args.textStyle);
                    },
                  ),
                  series: <CartesianSeries>[
                    if (controller.isVisible('Solar'))
                      ColumnSeries<YearChartData, DateTime>(
                        name: 'Solar',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.solar,
                        color: const Color(0xFF00C7E5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('REB'))
                      ColumnSeries<YearChartData, DateTime>(
                        name: 'REB',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.reb,
                        color: const Color(0xFFFF9F00),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Load'))
                      ColumnSeries<YearChartData, DateTime>(
                        name: 'Load',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.load,
                        color: const Color(0xFFD300C5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Generator'))
                      ColumnSeries<YearChartData, DateTime>(
                        name: 'Generator',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.gen,
                        color: const Color(0xFF0091FF),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('ESS'))
                      ColumnSeries<YearChartData, DateTime>(
                        name: 'ESS',
                        dataSource: allData,
                        xValueMapper: (d, _) => d.month,
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
          const SizedBox(height: 12),
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
                chartTitle: 'Yearly Solar Energy',
                rows: rows,
                dateFormat: 'MMM dd, yyyy',
                filePrefix: 'Yearly_SolarEnergy',
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
