import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearChartData {
  YearChartData(this.month, this.value);
  final String month;
  final double value;
}

class YearlyChartCard extends StatelessWidget {
  const YearlyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Replicating data: Apr ~65k, May ~115k
    final List<YearChartData> chartData = [
      YearChartData('Jan', 0),
      YearChartData('Feb', 0),
      YearChartData('Mar', 0),
      YearChartData('Apr', 65000),
      YearChartData('May', 115000),
      YearChartData('Jun', 0),
      YearChartData('Jul', 0),
      YearChartData('Aug', 0),
      YearChartData('Sep', 0),
      YearChartData('Oct', 0),
      YearChartData('Nov', 0),
      YearChartData('Dec', 0),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'This Year Solar Energy Chart',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2F50)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.file_download_outlined, color: Colors.grey.shade600, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Chart
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 250,
              child: SfCartesianChart(
                margin: const EdgeInsets.only(left: 0, top: 10, right: 10, bottom: 0),
                plotAreaBorderWidth: 1,
                plotAreaBorderColor: Colors.grey.shade300,
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: const InteractiveTooltip(enable: true, format: 'point.x : point.y'),
                ),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                    text: 'Month', // Keeping what user highlighted in SS
                    textStyle: const TextStyle(fontSize: 12, color: Color(0xFF1931A7)),
                  ),
                  majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 140000,
                  interval: 20000,
                  majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                  axisLabelFormatter: (AxisLabelRenderDetails args) {
                    final int val = args.value.toInt();
                    if (val == 0) return ChartAxisLabel('0', args.textStyle);

                    // Simulating the weird scale in the screenshot (0, 20k, 40k, 60k, 80k, 1M, 1.2M, 1.4M)
                    if (val == 100000) return ChartAxisLabel('1M', args.textStyle);
                    if (val == 120000) return ChartAxisLabel('1.2M', args.textStyle);
                    if (val == 140000) return ChartAxisLabel('1.4M', args.textStyle);

                    return ChartAxisLabel('${val ~/ 1000}k', args.textStyle);
                  },
                ),
                series: <CartesianSeries>[
                  ColumnSeries<YearChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (YearChartData data, _) => data.month,
                    yValueMapper: (YearChartData data, _) => data.value,
                    color: const Color(0xFF4A89F3),
                    // borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                    width: 0.7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
