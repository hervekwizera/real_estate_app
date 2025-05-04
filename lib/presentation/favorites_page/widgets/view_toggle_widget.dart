import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ViewToggleWidget extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onToggle;

  const ViewToggleWidget({
    Key? key,
    required this.isGridView,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: CustomIconWidget(
          key: ValueKey<bool>(isGridView),
          iconName: isGridView ? 'view_list' : 'grid_view',
          size: 24,
        ),
      ),
      tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
      onPressed: onToggle,
    );
  }
}
