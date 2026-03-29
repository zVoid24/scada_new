import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthChartData {
  MonthChartData(this.x, this.y);
  final double x;
  final double y;
}

class MonthlyChartCard extends StatelessWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MonthChartData> chartData = [
      MonthChartData(1, 51),
      MonthChartData(2, 20),
      MonthChartData(3, 29),
      MonthChartData(4, 5),
      MonthChartData(5, 49),
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'This Month Solar Energy Chart',
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

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              height: 250,
              child: SfCartesianChart(
                plotAreaBorderWidth: 1,
                plotAreaBorderColor: Colors.grey.shade300,

                // ✅ KEY FIX: Allow labels to render outside plot area bounds
                // clipBehavior: Clip.none,
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: const InteractiveTooltip(enable: true, format: 'Power : point.y kwh'),
                ),
                primaryXAxis: NumericAxis(
                  minimum: 0,
                  maximum: 31,
                  interval: 1,
                  plotOffset: 2,
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final int val = details.value.toInt();
                    if (val == 0) return ChartAxisLabel('', null);
                    return ChartAxisLabel(val.toString(), null);
                  },
                  title: AxisTitle(
                    text: 'Day',
                    textStyle: const TextStyle(fontSize: 15, color: Color(0xFF00059F)),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                ),

                primaryYAxis: NumericAxis(
                  // ✅ FIX: Extend max slightly above 60 so bar at 51
                  // has room for its label without hitting the top boundary
                  minimum: 0,
                  maximum: 65,
                  interval: 10,
                  // ✅ Hide the 65 tick — we only want 0,10,20,30,40,50,60
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final int val = details.value.toInt();
                    if (val > 60) return ChartAxisLabel('', null);
                    return ChartAxisLabel(val.toString(), null);
                  },
                  title: AxisTitle(
                    text: 'Power',
                    textStyle: const TextStyle(fontSize: 15, color: Color(0xFF00059F)),
                  ),
                  majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                ),

                series: <CartesianSeries>[
                  ColumnSeries<MonthChartData, double>(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data.x,
                    yValueMapper: (data, _) => data.y,
                    width: 1,
                    spacing: 0.2,
                    color: const Color(0xFF82B1FF),
                    // borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),

                    // dataLabelSettings: const DataLabelSettings(
                    //   isVisible: true,
                    //   angle: 270,
                    //   margin: EdgeInsets.zero,
                    //   labelPosition: ChartDataLabelPosition.inside,
                    //   labelAlignment: ChartDataLabelAlignment.middle,
                    //   labelIntersectAction: LabelIntersectAction.none,
                    //   textStyle: TextStyle(fontSize: 12, color: Color(0xFF1A2F50), fontWeight: FontWeight.bold),
                    // ),

                    // dataLabelMapper: (MonthChartData data, _) => data.y.toStringAsFixed(2),
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
