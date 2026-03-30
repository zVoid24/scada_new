import 'package:flutter/material.dart';

class ComponentItem {
  final String name;

  ComponentItem({required this.name});
}

class ComponentSelector extends StatefulWidget {
  const ComponentSelector({super.key});

  @override
  State<ComponentSelector> createState() => _ComponentSelectorState();
}

class _ComponentSelectorState extends State<ComponentSelector> {
  int _selectedIndex = 3; // 'Load' is selected in the image

  final List<ComponentItem> _components = [
    ComponentItem(name: 'Solar'),
    ComponentItem(name: 'Grid'),
    ComponentItem(name: 'ESS'),
    ComponentItem(name: 'Load'),
    ComponentItem(name: 'Generator'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _components.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0091FF) : Colors.white,
                    borderRadius: BorderRadius.circular(30), // Pill shape
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0091FF) : const Color(0xFFDDE1E6),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12, // Slightly smaller base font
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF9095A1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
