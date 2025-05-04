import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AmenitiesSelector extends StatelessWidget {
  final List<String> selectedAmenities;
  final Function(List<String>) onAmenitiesChanged;

  const AmenitiesSelector({
    Key? key,
    required this.selectedAmenities,
    required this.onAmenitiesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> amenities = [
      {'name': 'Air Conditioning', 'icon': 'ac_unit'},
      {'name': 'Heating', 'icon': 'whatshot'},
      {'name': 'Parking', 'icon': 'local_parking'},
      {'name': 'Swimming Pool', 'icon': 'pool'},
      {'name': 'Gym', 'icon': 'fitness_center'},
      {'name': 'WiFi', 'icon': 'wifi'},
      {'name': 'Laundry', 'icon': 'local_laundry_service'},
      {'name': 'Security', 'icon': 'security'},
      {'name': 'Elevator', 'icon': 'elevator'},
      {'name': 'Balcony', 'icon': 'balcony'},
      {'name': 'Garden', 'icon': 'yard'},
      {'name': 'Fireplace', 'icon': 'fireplace'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: amenities.map((amenity) {
        final isSelected = selectedAmenities.contains(amenity['name']);

        return GestureDetector(
          onTap: () {
            final updatedAmenities = List<String>.from(selectedAmenities);
            if (isSelected) {
              updatedAmenities.remove(amenity['name']);
            } else {
              updatedAmenities.add(amenity['name']);
            }
            onAmenitiesChanged(updatedAmenities);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: amenity['icon'],
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  amenity['name'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
