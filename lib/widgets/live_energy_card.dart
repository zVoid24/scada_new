import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LiveEnergyCard extends StatelessWidget {
  const LiveEnergyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      //padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFDDE1E6), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Live Energy Solar 01',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    '53.08 KW',
                    style: TextStyle(fontSize: 22, color: Color(0xFF0F2040), fontWeight: FontWeight.w900),
                  ),
                ),
                //const SizedBox(height: 12), // Spacer to balance the bottom part of the gauge
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 100, // Proportional height for standard gauges
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 1200,
                axes: <RadialAxis>[
                  RadialAxis(
                    radiusFactor: 1.1, // Ensures gauge fits within constraints without clipping labels
                    startAngle: 180,
                    endAngle: 360,
                    canScaleToFit: true,
                    minimum: 0,
                    maximum: 10,
                    interval: 2,
                    showLastLabel: true,
                    showLabels: true,
                    showTicks: false,
                    labelOffset: 12.0,
                    axisLabelStyle: const GaugeTextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Roboto'),
                    axisLineStyle: const AxisLineStyle(
                      thickness: 18.4,
                      color: Color(0xFFEEEEEE),
                      thicknessUnit: GaugeSizeUnit.logicalPixel,
                    ),

                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 5.3,
                        color: const Color(0xFF3B6EE3),
                        startWidth: 18.4,
                        endWidth: 18.4,
                        sizeUnit: GaugeSizeUnit.logicalPixel,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: 5.3,
                        needleColor: const Color(0xFF1931A7),
                        lengthUnit: GaugeSizeUnit.factor,
                        needleLength: 0.75,
                        needleStartWidth: 1,
                        needleEndWidth: 4.8,
                        knobStyle: const KnobStyle(
                          knobRadius: 3.84,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          color: Color(0xFF1931A7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
