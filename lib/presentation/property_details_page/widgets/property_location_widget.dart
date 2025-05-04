import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PropertyLocationWidget extends StatelessWidget {
  final String? address;
  final String? mapImageUrl;

  const PropertyLocationWidget({
    Key? key,
    this.address,
    this.mapImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          address ?? 'Address not available',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // Open map functionality
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                CustomImageWidget(
                  imageUrl: mapImageUrl ??
                      'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&key=YOUR_API_KEY',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'directions',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
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
}
