import 'package:flutter/material.dart';

class ComponentItem {
  final String name;
  final String assetPath;

  ComponentItem({required this.name, required this.assetPath});
}

class ComponentSelector extends StatefulWidget {
  const ComponentSelector({super.key});

  @override
  State<ComponentSelector> createState() => _ComponentSelectorState();
}

class _ComponentSelectorState extends State<ComponentSelector> {
  int _selectedIndex = 3; // 'Load' is selected in the image

  final List<ComponentItem> _components = [
    ComponentItem(name: 'Solar', assetPath: 'assets/Solar.png'),
    ComponentItem(name: 'Grid', assetPath: 'assets/Grid.png'),
    ComponentItem(name: 'ESS', assetPath: 'assets/ESS.png'),
    ComponentItem(name: 'Load', assetPath: 'assets/Load.png'),
    ComponentItem(name: 'Generator', assetPath: 'assets/Generator.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
          child: Text(
            'Select Components -',
            style: TextStyle(fontSize: 16, color: Color(0xFF5E5E5E), fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: _components.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;
              final item = _components[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E88E5) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item.assetPath, width: 35, height: 35, fit: BoxFit.contain),
                      //const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
