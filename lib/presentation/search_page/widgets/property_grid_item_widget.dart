import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PropertyGridItemWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const PropertyGridItemWidget({
    Key? key,
    required this.property,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? AppTheme.shadowDark.withValues(alpha: 0.3)
                  : AppTheme.shadowLight.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Hero(
                      tag: 'property_${property['id']}_grid',
                      child: CustomImageWidget(
                        imageUrl: property['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Price Tag
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        property['price'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite indicator
                  if (property['isFavorite'] == true)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.surface.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.favorite,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Property Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const CustomIconWidget(
                        iconName: 'location_on',
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          property['address'],
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Property Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeature(
                        context,
                        'bed',
                        '${property['bedrooms']}',
                      ),
                      _buildFeature(
                        context,
                        'bathtub',
                        '${property['bathrooms']}',
                      ),
                      _buildFeature(
                        context,
                        'square_foot',
                        '${property['area']}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, String iconName, String text) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
