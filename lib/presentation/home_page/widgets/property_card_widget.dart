import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PropertyCardWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final Function(bool) onFavoriteToggle;

  const PropertyCardWidget({
    Key? key,
    required this.property,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
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
            // Property Image with Price Tag and Favorite Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Hero(
                      tag: 'property_${property['id']}',
                      child: CustomImageWidget(
                        imageUrl: property['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Price Tag
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      property['price'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      onFavoriteToggle(!property['isFavorite']);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: property['isFavorite']
                            ? 'favorite'
                            : 'favorite_border',
                        color:
                            property['isFavorite'] ? AppTheme.favorite : null,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Property Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
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
                        size: 16,
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
                  const SizedBox(height: 12),
                  // Property Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeature(
                        context,
                        'bed',
                        '${property['bedrooms']} ${property['bedrooms'] == 1 ? 'Bed' : 'Beds'}',
                      ),
                      _buildFeature(
                        context,
                        'bathtub',
                        '${property['bathrooms']} ${property['bathrooms'] == 1 ? 'Bath' : 'Baths'}',
                      ),
                      _buildFeature(
                        context,
                        'square_foot',
                        '${property['area']} ft²',
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
          size: 18,
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
