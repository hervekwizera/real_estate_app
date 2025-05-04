import 'package:flutter/material.dart';

class PropertyDetailsPage extends StatelessWidget {
  final int? propertyId;

  const PropertyDetailsPage({
    Key? key,
    this.propertyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Property Details Page: ${propertyId ?? 'No ID'}'),
      ),
    );
  }
}
