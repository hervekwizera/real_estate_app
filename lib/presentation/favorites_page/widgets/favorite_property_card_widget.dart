import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FavoritePropertyCardWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isGridView;

  const FavoritePropertyCardWidget({
    Key? key,
    required this.property,
    required this.onTap,
    required this.onRemove,
    required this.isGridView,
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
        child: isGridView ? _buildGridCard(context) : _buildListCard(context),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Image with Category Tag and Remove Button
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: 'favorite_${property['id']}',
                  child: CustomImageWidget(
                    imageUrl: property['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Category Tag
            if (property['category'] != null)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    property['category'],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Remove Button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.error,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Price Tag
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  property['price'],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Property Details
        Padding(
          padding: const EdgeInsets.all(8),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Hero(
              tag: 'favorite_${property['id']}',
              child: CustomImageWidget(
                imageUrl: property['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Property Details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.error,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
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
                Text(
                  property['price'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
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
                if (property['category'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        property['category'],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
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
