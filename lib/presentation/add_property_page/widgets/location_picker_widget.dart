import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationPickerWidget extends StatefulWidget {
  final Map<String, dynamic> initialLocation;
  final Function(Map<String, dynamic>) onLocationSelected;

  const LocationPickerWidget({
    Key? key,
    required this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: widget.initialLocation['address'] ?? '');
    _cityController =
        TextEditingController(text: widget.initialLocation['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.initialLocation['state'] ?? '');
    _zipCodeController =
        TextEditingController(text: widget.initialLocation['zipCode'] ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _updateLocation() {
    final location = {
      'address': _addressController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipCode': _zipCodeController.text,
      'coordinates':
          widget.initialLocation['coordinates'] ?? {'lat': 0.0, 'lng': 0.0},
    };
    widget.onLocationSelected(location);
  }

  void _toggleMap() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            prefixIcon: CustomIconWidget(iconName: 'location_on'),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (value) {
            _updateLocation();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the street address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _updateLocation();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _updateLocation();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'ZIP',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateLocation();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _toggleMap,
          icon: CustomIconWidget(
            iconName: _showMap ? 'map' : 'add_location',
          ),
          label: Text(_showMap ? 'Hide Map' : 'Pin on Map'),
        ),
        if (_showMap) ...[
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomIconWidget(
                        iconName: 'map',
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Map View',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'In a real app, this would show an interactive map',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const CustomIconWidget(iconName: 'close'),
                    onPressed: _toggleMap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
