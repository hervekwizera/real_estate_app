import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PropertyListItemWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const PropertyListItemWidget({
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Hero(
                      tag: 'property_${property['id']}_list',
                      child: CustomImageWidget(
                        imageUrl: property['imageUrl'],
                        fit: BoxFit.cover,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property['title'],
                      style: theme.textTheme.titleSmall?.copyWith(
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
                          size: 14,
                        ),
                        const SizedBox(width: 4),
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
                    // Price
                    Text(
                      property['price'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Property Features
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildFeature(
                          context,
                          'bed',
                          '${property['bedrooms']}',
                        ),
                        const SizedBox(width: 16),
                        _buildFeature(
                          context,
                          'bathtub',
                          '${property['bathrooms']}',
                        ),
                        const SizedBox(width: 16),
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
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
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
