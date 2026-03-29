import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  bool _isTodayData = true;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(0, 2),
      ChartData(2.5, 5),
      ChartData(4.5, 2.5),
      ChartData(7.5, 6.2),
      ChartData(11.0, 3.1),
      ChartData(14.0, 6.8),
      ChartData(17.2, 2.9),
      ChartData(19.0, 7.3),
      ChartData(22.0, 1.9),
      ChartData(24.0, 7.1),
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
          // Toggle Buttons
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildToggleButton('Today Data', _isTodayData, () {
                      setState(() => _isTodayData = true);
                    }),
                    const SizedBox(width: 8),
                    _buildToggleButton('Custom Date', !_isTodayData, () {
                      setState(() => _isTodayData = false);
                    }),
                  ],
                ),
                if (!_isTodayData) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePickerField(
                          hint: 'From Date',
                          selectedDate: _fromDate,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _fromDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _fromDate = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDatePickerField(
                          hint: 'To Date',

                          selectedDate: _toDate,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _toDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _toDate = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF008BFC)),
                        ),
                        child: const Icon(Icons.search, color: Color(0xFF008BFC), size: 27),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.show_chart, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Solar Energy 01 (kw) Chart',
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
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: const InteractiveTooltip(enable: true, format: 'Power : point.y kw'),
                ),
                margin: const EdgeInsets.only(left: 0, top: 10, right: 10, bottom: 10),
                plotAreaBorderWidth: 1,
                plotAreaBorderColor: Colors.grey.shade300,
                primaryXAxis: NumericAxis(
                  minimum: 0,
                  maximum: 24,
                  interval: 4,
                  labelFormat: '{value}.0',
                  title: AxisTitle(
                    text: 'Hour',
                    textStyle: const TextStyle(fontSize: 15, color: Color(0xFF00059F)),
                  ),
                  majorGridLines: MajorGridLines(color: Colors.grey.shade200),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 10,
                  interval: 2,
                  title: AxisTitle(
                    text: 'Power',
                    textStyle: const TextStyle(fontSize: 15, color: Color(0xFF00059F)),
                  ),
                  majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                  axisLine: const AxisLine(width: 1, color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                ),
                series: <CartesianSeries>[
                  SplineSeries<ChartData, double>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: ChoiceChip(
        label: Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive) ...[
                const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        selected: isActive,
        onSelected: (_) => onTap(),
        selectedColor: const Color(0xFF0096FC),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: isActive ? Colors.white : Color(0xFF9AA9BC)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: isActive ? const Color(0xFF0096FC) : Color(0xFF9AA9BC)),
        ),
        showCheckmark: false,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDatePickerField({required String hint, DateTime? selectedDate, required VoidCallback onTap}) {
    final String displayText = selectedDate != null
        ? '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'
        : hint;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEBF3FC), // Light slightly blue-grey tint
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: TextStyle(
                color: selectedDate != null ? Colors.black87 : Color(0xFF646984),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.calendar_today_outlined, color: Color(0xFF646984), size: 21),
          ],
        ),
      ),
    );
  }
}
