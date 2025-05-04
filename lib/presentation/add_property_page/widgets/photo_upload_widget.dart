import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PhotoUploadWidget extends StatefulWidget {
  final List<String> photos;
  final Function(List<String>) onPhotosChanged;

  const PhotoUploadWidget({
    Key? key,
    required this.photos,
    required this.onPhotosChanged,
  }) : super(key: key);

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  final List<String> _mockPhotos = [
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
    'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
  ];

  void _addPhoto(String source) {
    // In a real app, this would open the camera or gallery
    // For this demo, we'll add a mock photo
    if (widget.photos.length < 10) {
      final updatedPhotos = List<String>.from(widget.photos);
      updatedPhotos.add(_mockPhotos[widget.photos.length % _mockPhotos.length]);
      widget.onPhotosChanged(updatedPhotos);
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(widget.photos);
    updatedPhotos.removeAt(index);
    widget.onPhotosChanged(updatedPhotos);
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final updatedPhotos = List<String>.from(widget.photos);
    final item = updatedPhotos.removeAt(oldIndex);
    updatedPhotos.insert(newIndex, item);
    widget.onPhotosChanged(updatedPhotos);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addPhoto('camera'),
                icon: const CustomIconWidget(iconName: 'camera_alt'),
                label: const Text('Take Photo'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addPhoto('gallery'),
                icon: const CustomIconWidget(iconName: 'photo_library'),
                label: const Text('Gallery'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Photo count
        Text(
          '${widget.photos.length} / 10 photos added',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 16),

        // Photo grid
        if (widget.photos.isEmpty)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomIconWidget(
                  iconName: 'add_photo_alternate',
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No photos added yet',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add photos to showcase your property',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ReorderableGridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: widget.photos.length,
            onReorder: _reorderPhotos,
            itemBuilder: (context, index) {
              return Stack(
                key: ValueKey(widget.photos[index]),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: index == 0
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CustomImageWidget(
                        imageUrl: widget.photos[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Cover',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          size: 16,
                          color: theme.colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class ReorderableGridView extends StatelessWidget {
  final Widget child;
  final Function(int oldIndex, int newIndex) onReorder;

  const ReorderableGridView({
    Key? key,
    required this.child,
    required this.onReorder,
  }) : super(key: key);

  static Builder builder({
    required SliverGridDelegate gridDelegate,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required Function(int oldIndex, int newIndex) onReorder,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return Builder(
      builder: (context) {
        return ReorderableGridView(
          onReorder: onReorder,
          child: GridView.builder(
            gridDelegate: gridDelegate,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            shrinkWrap: shrinkWrap,
            physics: physics,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, this would be a proper reorderable grid view
    // For this demo, we'll just return the child
    return child;
  }
}
