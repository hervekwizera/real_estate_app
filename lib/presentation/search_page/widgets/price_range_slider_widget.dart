import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'package:intl/intl.dart';

class PriceRangeSliderWidget extends StatelessWidget {
  final RangeValues currentRange;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;
  final Function(RangeValues) onChangeEnd;

  const PriceRangeSliderWidget({
    Key? key,
    required this.currentRange,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      children: [
        RangeSlider(
          values: currentRange,
          min: min,
          max: max,
          divisions: 50,
          labels: RangeLabels(
            currencyFormat.format(currentRange.start),
            currencyFormat.format(currentRange.end),
          ),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormat.format(currentRange.start),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                currencyFormat.format(currentRange.end),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
