import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PropertySpecsWidget extends StatelessWidget {
  final int? bedrooms;
  final double? bathrooms;
  final int? area;
  final int? yearBuilt;

  const PropertySpecsWidget({
    Key? key,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.yearBuilt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSpecItem(
            context,
            'bed',
            '${bedrooms ?? 0}',
            'Bedrooms',
          ),
          _buildDivider(context),
          _buildSpecItem(
            context,
            'bathtub',
            '${bathrooms ?? 0}',
            'Bathrooms',
          ),
          _buildDivider(context),
          _buildSpecItem(
            context,
            'square_foot',
            '${area ?? 0}',
            'Sq Ft',
          ),
          _buildDivider(context),
          _buildSpecItem(
            context,
            'calendar_today',
            '${yearBuilt ?? 'N/A'}',
            'Year Built',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(
      BuildContext context, String iconName, String value, String label) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
