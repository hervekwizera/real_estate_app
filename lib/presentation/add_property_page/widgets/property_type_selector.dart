import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PropertyTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const PropertyTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> propertyTypes = [
      {
        "type": "House",
        "icon": "home",
      },
      {
        "type": "Apartment",
        "icon": "apartment",
      },
      {
        "type": "Villa",
        "icon": "villa",
      },
      {
        "type": "Office",
        "icon": "business",
      },
      {
        "type": "Land",
        "icon": "landscape",
      },
      {
        "type": "Commercial",
        "icon": "storefront",
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: propertyTypes.length,
      itemBuilder: (context, index) {
        final type = propertyTypes[index];
        final isSelected = type['type'] == selectedType;

        return GestureDetector(
          onTap: () => onTypeSelected(type['type']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: type['icon'],
                  size: 32,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  type['type'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
