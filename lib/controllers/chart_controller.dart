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

  // --- Pagination ---
  final monthlyPage = 0.obs; // 0: 1-10, 1: 11-20, 2: 21-31
  final yearlyPage = 0.obs;  // 0: Jan-Jun, 1: Jul-Dec

  void nextMonthly() {
    if (monthlyPage.value < 2) monthlyPage.value++;
  }

  void prevMonthly() {
    if (monthlyPage.value > 0) monthlyPage.value--;
  }

  void nextYearly() {
    if (yearlyPage.value < 1) yearlyPage.value++;
  }

  void prevYearly() {
    if (yearlyPage.value > 0) yearlyPage.value--;
  }
}
