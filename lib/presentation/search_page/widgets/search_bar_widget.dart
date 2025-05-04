import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSearch;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: 'Search by location, price, or property type',
          prefixIcon: const CustomIconWidget(
            iconName: 'search',
            size: 24,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const CustomIconWidget(
                    iconName: 'clear',
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
      ),
    );
  }
}
