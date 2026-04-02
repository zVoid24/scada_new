import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

class MonthlyChartCard extends StatefulWidget {
  const MonthlyChartCard({super.key});

  @override
  State<MonthlyChartCard> createState() => _MonthlyChartCardState();
}

class _MonthlyChartCardState extends State<MonthlyChartCard> {
  final GlobalKey _offscreenChartKey = GlobalKey();
  final RxBool _isGenerating = false.obs;

  Future<Uint8List?> _captureChart() async {
    try {
      _isGenerating.value = true;
      // Allow one frame for the ghost chart to be added to the tree and rendered
      await Future.delayed(Duration.zero);
      await WidgetsBinding.instance.endOfFrame;

      final RenderRepaintBoundary? boundary = _offscreenChartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing monthly ghost chart: $e');
      return null;
    } finally {
      _isGenerating.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final List<MonthChartData> allData = List.generate(daysInMonth, (i) {
      final DateTime date = DateTime(now.year, now.month, i + 1);
      return MonthChartData(
        date,
        20.0 + (i % 5) * 10,
        15.0 + (i % 3) * 12,
        30.0 + (i % 4) * 8,
        10.0 + (i % 6) * 5,
        25.0 + (i % 2) * 15,
      );
    });

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Ghost Chart (Rendered only on-demand during export)
          Obx(
            () => _isGenerating.value
                ? Positioned(
                    left: -5000,
                    top: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 220,
                      child: RepaintBoundary(
                        key: _offscreenChartKey,
                        child: _buildChart(controller, allData, isGhost: true),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 2. Visible UI
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader('This Month Solar Energy - kWh', context, downloadRows),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 220,
                  child: Obx(
                    () => _buildChart(controller, allData, isGhost: false),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ChartController controller, List<MonthChartData> data, {required bool isGhost}) {
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return SfCartesianChart(
      margin: const EdgeInsets.only(left: 10, top: 10, right: 15, bottom: 10),
      plotAreaBorderWidth: 1,
      plotAreaBorderColor: Colors.grey.shade300,
      zoomPanBehavior: isGhost ? null : ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x),
      trackballBehavior: isGhost
          ? null
          : TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.longPress,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            ),
      primaryXAxis: DateTimeCategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
        interval: 1,
        intervalType: DateTimeIntervalType.days,
        // Ghost chart always shows full month
        initialVisibleMinimum: isGhost
            ? null
            : (now.day <= 15 ? DateTime(now.year, now.month, 1) : DateTime(now.year, now.month, 16)),
        initialVisibleMaximum: isGhost
            ? null
            : (now.day <= 15 ? DateTime(now.year, now.month, 15) : DateTime(now.year, now.month, daysInMonth)),
        labelPlacement: LabelPlacement.betweenTicks,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
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
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.solar,
            color: const Color(0xFF00C7E5),
            width: 0.8,
            spacing: 0.1,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Grid'))
          ColumnSeries<MonthChartData, DateTime>(
            name: 'Grid',
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.grid,
            color: const Color(0xFFFF9F00),
            width: 0.8,
            spacing: 0.1,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Load'))
          ColumnSeries<MonthChartData, DateTime>(
            name: 'Load',
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.load,
            color: const Color(0xFFD300C5),
            width: 0.8,
            spacing: 0.1,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('Generator'))
          ColumnSeries<MonthChartData, DateTime>(
            name: 'Generator',
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.gen,
            color: const Color(0xFF0091FF),
            width: 0.8,
            spacing: 0.1,
            animationDuration: isGhost ? 0 : 1500,
          ),
        if (controller.isVisible('ESS'))
          ColumnSeries<MonthChartData, DateTime>(
            name: 'ESS',
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.ess,
            color: const Color(0xFF7ED321),
            width: 0.8,
            spacing: 0.1,
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
