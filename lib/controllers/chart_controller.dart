import 'package:get/get.dart';

class ChartController extends GetxController {
  // --- Series Visibility ---
  final Map<String, bool> _isVisible = {
    'Solar': true,
    'REB': true,
    'Load': true,
    'Generator': true,
    'ESS': true,
  }.obs;

  bool isVisible(String name) => _isVisible[name] ?? true;

  void toggleSeries(String name) {
    if (_isVisible.containsKey(name)) {
      _isVisible[name] = !(_isVisible[name]!);
    }
  }
}
