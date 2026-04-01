import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/chart_controller.dart';
import '../services/chart_download_service.dart';

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}

class ChartCard extends StatefulWidget {
  const ChartCard({super.key});

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  final GlobalKey _offscreenChartKey = GlobalKey();

  Future<Uint8List?> _captureChart() async {
    try {
      await WidgetsBinding.instance.endOfFrame;
      final RenderRepaintBoundary? boundary = _offscreenChartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing daily ghost chart: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    final List<ChartData> solarData = [
      ChartData(0, 2), ChartData(4, 5), ChartData(8, 2.5), ChartData(12, 6.2),
      ChartData(16, 3.1), ChartData(20, 6.8), ChartData(24, 2.9),
    ];
    final List<ChartData> gridData = [
      ChartData(0, 3), ChartData(4, 3.5), ChartData(8, 5.5), ChartData(12, 3),
      ChartData(16, 5.5), ChartData(20, 2.5), ChartData(24, 6),
    ];
    final List<ChartData> loadData = [
      ChartData(0, 4.5), ChartData(4, 6.5), ChartData(8, 3.5), ChartData(12, 5.8),
      ChartData(16, 4.2), ChartData(20, 5.5), ChartData(24, 3.8),
    ];
    final List<ChartData> genData = [
      ChartData(0, 5.5), ChartData(4, 2.2), ChartData(8, 4.8), ChartData(12, 4.1),
      ChartData(16, 6.3), ChartData(20, 3.2), ChartData(24, 5.2),
    ];
    final List<ChartData> essData = [
      ChartData(0, 2.5), ChartData(4, 4.8), ChartData(8, 6.2), ChartData(12, 3.5),
      ChartData(16, 4.5), ChartData(20, 6.1), ChartData(24, 4.3),
    ];

    final DateTime today = DateTime.now();
    final List<ChartRowData> downloadRows = List.generate(solarData.length, (i) {
      final int hour = solarData[i].x.toInt();
      return ChartRowData(
        dateTime: DateTime(today.year, today.month, today.day, hour),
        solar: solarData[i].y,
        grid: gridData[i].y,
        load: loadData[i].y,
        generator: genData[i].y,
        ess: essData[i].y,
      );
    });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Ghost Chart (Hidden Off-Screen, No Animation)
          Positioned(
            left: -5000,
            top: 100, // Offset a bit from the header area of the stack
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 220,
              child: RepaintBoundary(
                key: _offscreenChartKey,
                child: Obx(
                  () => _buildChart(controller, solarData, gridData, loadData, genData, essData, isGhost: true),
                ),
              ),
            ),
          ),

          // 2. Visible UI
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader('This Day Power Trend -kW', context, downloadRows),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 220,
                  child: Obx(
                    () => _buildChart(controller, solarData, gridData, loadData, genData, essData, isGhost: false),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    ChartController controller,
    List<ChartData> solar,
    List<ChartData> grid,
    List<ChartData> load,
    List<ChartData> gen,
    List<ChartData> ess, {
    required bool isGhost,
  }) {
    return SfCartesianChart(
      margin: const EdgeInsets.only(left: 10, top: 10, right: 15, bottom: 10),
      plotAreaBorderWidth: 1,
      plotAreaBorderColor: Colors.grey.shade300,
      trackballBehavior: isGhost
          ? null
          : TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.longPress,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            ),
      primaryXAxis: NumericAxis(
        minimum: 0,
        maximum: 24,
        interval: 4,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          final int hour = details.value.toInt();
          return ChartAxisLabel('${hour.toString().padLeft(2, '0')}:00', details.textStyle);
        },
        majorGridLines: MajorGridLines(color: Colors.grey.shade200),
        axisLine: const AxisLine(width: 1, color: Colors.grey),
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 10,
        interval: 2,
        majorGridLines: MajorGridLines(color: Colors.grey.shade300),
        axisLine: const AxisLine(width: 1, color: Colors.grey),
        maximumLabelWidth: 15,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
      ),
      series: <CartesianSeries>[
        if (controller.isVisible('Solar'))
          SplineSeries<ChartData, double>(
            name: 'Solar',
            dataSource: solar,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00C7E5),
            width: 2,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Grid'))
          SplineSeries<ChartData, double>(
            name: 'Grid',
            dataSource: grid,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFFF9F00),
            width: 2,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Load'))
          SplineSeries<ChartData, double>(
            name: 'Load',
            dataSource: load,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFD300C5),
            width: 2,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Generator'))
          SplineSeries<ChartData, double>(
            name: 'Generator',
            dataSource: gen,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF0091FF),
            width: 2,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('ESS'))
          SplineSeries<ChartData, double>(
            name: 'ESS',
            dataSource: ess,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF7ED321),
            width: 2,
            animationDuration: isGhost ? 0 : 1500,
          ),
      ],
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
                  child: const Icon(Icons.show_chart, color: Color(0xFF6E87A8), size: 18),
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
                chartTitle: 'Daily Power Trend',
                rows: rows,
                dateFormat: 'dd-MMM-yyyy HH:00',
                filePrefix: 'Daily_PowerTrend',
                unit: 'kW',
                onCaptureChart: _captureChart,
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
