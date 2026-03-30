import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';

class YearChartData {
  YearChartData(this.month, this.solar, this.reb, this.load, this.gen, this.ess);
  final String month;
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
      YearChartData('Jan', 15000, 12000, 25000, 8000, 18000),
      YearChartData('Feb', 18000, 14000, 22000, 9000, 16000),
      YearChartData('Mar', 25000, 18000, 20000, 12000, 22000),
      YearChartData('Apr', 65000, 45000, 55000, 30000, 40000),
      YearChartData('May', 115000, 85000, 95000, 60000, 75000),
      YearChartData('Jun', 90000, 70000, 80000, 50000, 65000),
      YearChartData('Jul', 95000, 75000, 85000, 55000, 70000),
      YearChartData('Aug', 100000, 80000, 90000, 60000, 75000),
      YearChartData('Sep', 85000, 65000, 75000, 45000, 60000),
      YearChartData('Oct', 70000, 55000, 65000, 35000, 50000),
      YearChartData('Nov', 40000, 30000, 45000, 20000, 35000),
      YearChartData('Dec', 20000, 15000, 30000, 10000, 25000),
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
          _buildHeader('This Yearly Solar Energy - kWh'),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 220,
              child: Obx(() {
                final int page = controller.yearlyPage.value;
                final List<YearChartData> pagedData = page == 0 ? allData.sublist(0, 6) : allData.sublist(6, 12);

                return SfCartesianChart(
                  margin: EdgeInsets.zero,
                  plotAreaBorderWidth: 1,
                  plotAreaBorderColor: Colors.grey.shade300,
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    tooltipSettings: const InteractiveTooltip(enable: true, format: 'series.name : point.y kWh'),
                  ),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                    labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
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
                          '${(val / 100000).toStringAsFixed(1)}M'.replaceFirst('.0', ''),
                          args.textStyle,
                        );
                      return ChartAxisLabel('${val ~/ 1000}k', args.textStyle);
                    },
                  ),
                  series: <CartesianSeries>[
                    if (controller.isVisible('Solar'))
                      ColumnSeries<YearChartData, String>(
                        name: 'Solar',
                        dataSource: pagedData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.solar,
                        color: const Color(0xFF00C7E5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('REB'))
                      ColumnSeries<YearChartData, String>(
                        name: 'REB',
                        dataSource: pagedData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.reb,
                        color: const Color(0xFFFF9F00),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Load'))
                      ColumnSeries<YearChartData, String>(
                        name: 'Load',
                        dataSource: pagedData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.load,
                        color: const Color(0xFFD300C5),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('Generator'))
                      ColumnSeries<YearChartData, String>(
                        name: 'Generator',
                        dataSource: pagedData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.gen,
                        color: const Color(0xFF0091FF),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                    if (controller.isVisible('ESS'))
                      ColumnSeries<YearChartData, String>(
                        name: 'ESS',
                        dataSource: pagedData,
                        xValueMapper: (d, _) => d.month,
                        yValueMapper: (d, _) => d.ess,
                        color: const Color(0xFF7ED321),
                        width: 0.8,
                        spacing: 0.1,
                      ),
                  ],
                );
              }),
            ),
          ),
          _buildPagination(controller),
          const SizedBox(height: 8),
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
            child: const Icon(Icons.bar_chart, color: Color(0xFF0091FF), size: 18),
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

  Widget _buildPagination(ChartController controller) {
    return Obx(() {
      final int page = controller.yearlyPage.value;
      final String label = page == 0 ? "January - June" : "July - December";

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, color: Color(0xFF0091FF)),
            onPressed: page > 0 ? controller.prevYearly : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_right, color: Color(0xFF0091FF)),
            onPressed: page < 1 ? controller.nextYearly : null,
          ),
        ],
      );
    });
  }
}
