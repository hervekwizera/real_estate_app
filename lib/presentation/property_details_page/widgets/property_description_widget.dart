import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PropertyDescriptionWidget extends StatefulWidget {
  final String? description;

  const PropertyDescriptionWidget({
    Key? key,
    this.description,
  }) : super(key: key);

  @override
  State<PropertyDescriptionWidget> createState() =>
      _PropertyDescriptionWidgetState();
}

class _PropertyDescriptionWidgetState extends State<PropertyDescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = widget.description ?? 'No description available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'description',
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (description.length > 150)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  icon: const CustomIconWidget(
                    iconName: 'expand_more',
                    size: 20,
                  ),
                  label: const Text('Read more'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                ),
            ],
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                icon: const CustomIconWidget(
                  iconName: 'expand_less',
                  size: 20,
                ),
                label: const Text('Show less'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
