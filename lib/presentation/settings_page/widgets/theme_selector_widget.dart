import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ThemeSelectorWidget({
    Key? key,
    required this.selectedTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const CustomIconWidget(
                  iconName: 'palette',
                  color: AppTheme.primary600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose your preferred app theme',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  context,
                  title: 'Light',
                  iconName: 'light_mode',
                  value: 'light',
                  backgroundColor: AppTheme.neutral50,
                  textColor: AppTheme.neutral900,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeOption(
                  context,
                  title: 'Dark',
                  iconName: 'dark_mode',
                  value: 'dark',
                  backgroundColor: AppTheme.neutral900,
                  textColor: AppTheme.neutral50,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeOption(
                  context,
                  title: 'System',
                  iconName: 'settings_suggest',
                  value: 'system',
                  backgroundColor: AppTheme.primary100,
                  textColor: AppTheme.primary900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String iconName,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final isSelected = selectedTheme == value;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onThemeChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: textColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              CustomIconWidget(
                iconName: 'check_circle',
                color: theme.colorScheme.primary,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
