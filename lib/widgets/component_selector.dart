import 'package:flutter/material.dart';

class ComponentItem {
  final String name;

  ComponentItem({required this.name});
}

class ComponentSelector extends StatefulWidget {
  final String? initialComponentName;
  const ComponentSelector({super.key, this.initialComponentName});

  @override
  State<ComponentSelector> createState() => _ComponentSelectorState();
}

class _ComponentSelectorState extends State<ComponentSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3; // Default to 'Load' if no match
    if (widget.initialComponentName != null) {
      final index = _components.indexWhere((c) => c.name.toLowerCase() == widget.initialComponentName!.toLowerCase());
      if (index != -1) {
        _selectedIndex = index;
      }
    }
  }

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
              child: ChoiceChip(
                label: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF9095A1),
                    ),
                  ),
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                },
                selectedColor: const Color(0xFF0091FF),
                backgroundColor: Colors.white,
                showCheckmark: false,
                labelPadding: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF0091FF) : const Color(0xFFDDE1E6),
                    width: 1.2,
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
