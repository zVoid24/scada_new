import 'package:flutter/material.dart';

class EnergyInfoCard extends StatelessWidget {
  const EnergyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Solar 01 Energy & Runtime Information',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'Today Runtime',
            value: '11 hrs. 21 min',
            backgroundColor: const Color(0xFF793BE8).withOpacity(0.12),
            textColor: const Color(0xFF793BE8),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'This Day',
            value: '159.52 kwh',
            backgroundColor: const Color(0xFF2D98ED).withOpacity(0.12),
            textColor: const Color(0xFF2D98ED),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'This Month',
            value: '2832.53 kwh',
            backgroundColor: Color(0xFFE99D2D).withOpacity(0.12),
            textColor: const Color(0xFFE99D2D),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'This Year',
            value: '54349.82 kwh',
            backgroundColor: const Color(0xFF13A6A6).withOpacity(0.12),
            textColor: const Color(0xFF13A6A6),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            ':',
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
