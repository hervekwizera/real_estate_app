import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedFiltersWidget extends StatelessWidget {
  final int selectedBedrooms;
  final int selectedBathrooms;
  final List<String> selectedAmenities;
  final List<String> amenitiesList;
  final Function(int) onBedroomsChanged;
  final Function(int) onBathroomsChanged;
  final Function(String) onAmenityToggled;
  final VoidCallback onResetFilters;

  const AdvancedFiltersWidget({
    Key? key,
    required this.selectedBedrooms,
    required this.selectedBathrooms,
    required this.selectedAmenities,
    required this.amenitiesList,
    required this.onBedroomsChanged,
    required this.onBathroomsChanged,
    required this.onAmenityToggled,
    required this.onResetFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bedrooms filter
          Text(
            'Bedrooms',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNumberFilterChip(context, 'Any', 0),
                _buildNumberFilterChip(context, '1+', 1),
                _buildNumberFilterChip(context, '2+', 2),
                _buildNumberFilterChip(context, '3+', 3),
                _buildNumberFilterChip(context, '4+', 4),
                _buildNumberFilterChip(context, '5+', 5),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bathrooms filter
          Text(
            'Bathrooms',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNumberFilterChip(context, 'Any', 0),
                _buildNumberFilterChip(context, '1+', 1),
                _buildNumberFilterChip(context, '2+', 2),
                _buildNumberFilterChip(context, '3+', 3),
                _buildNumberFilterChip(context, '4+', 4),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Amenities filter
          Text(
            'Amenities',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenitiesList.map((amenity) {
              final isSelected = selectedAmenities.contains(amenity);
              return GestureDetector(
                onTap: () => onAmenityToggled(amenity),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    amenity,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Reset filters button
          Center(
            child: OutlinedButton.icon(
              onPressed: onResetFilters,
              icon: const CustomIconWidget(
                iconName: 'refresh',
                size: 18,
              ),
              label: const Text('Reset All Filters'),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNumberFilterChip(BuildContext context, String label, int value) {
    final theme = Theme.of(context);
    final isSelected = value == 0
        ? selectedBedrooms == 0 && label == 'Any' ||
            selectedBathrooms == 0 && label == 'Any'
        : label.contains('Bed')
            ? selectedBedrooms == value
            : selectedBathrooms == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          if (label.contains('Bed') ||
              (label == 'Any' && selectedBathrooms != 0)) {
            onBedroomsChanged(value);
          } else {
            onBathroomsChanged(value);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
