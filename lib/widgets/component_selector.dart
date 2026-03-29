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
            style: TextStyle(fontSize: 20, color: Color(0xFF5E5E5E), fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 70,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500), // Max width for tablet/landscape
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _components.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = _selectedIndex == index;

                      // Dynamic font size based on width
                      final double fontSize = constraints.maxWidth > 400 ? 13 : 11;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Container(
                            height: double.infinity,
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
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
