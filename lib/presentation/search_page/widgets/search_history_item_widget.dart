import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHistoryItemWidget extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryItemWidget({
    Key? key,
    required this.query,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: const CustomIconWidget(
        iconName: 'history',
        size: 20,
      ),
      title: Text(
        query,
        style: theme.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const CustomIconWidget(
          iconName: 'close',
          size: 16,
        ),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
