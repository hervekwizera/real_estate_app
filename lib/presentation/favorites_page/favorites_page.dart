import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/empty_favorites_widget.dart';
import './widgets/favorite_property_card_widget.dart';
import './widgets/view_toggle_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  bool _isGridView = true;
  bool _isLoading = true;
  List<Map<String, dynamic>> _favoriteProperties = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadFavoriteProperties();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteProperties() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _favoriteProperties = _getMockFavoriteProperties();
      _isLoading = false;
    });
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _navigateToPropertyDetails(int propertyId) {
    Navigator.pushNamed(context, '/property-details-page',
        arguments: {'propertyId': propertyId});
  }

  void _navigateToHomePage() {
    Navigator.pushNamed(context, '/home-page');
  }

  void _navigateToSearchPage() {
    Navigator.pushNamed(context, '/search-page');
  }

  void _navigateToSettingsPage() {
    Navigator.pushNamed(context, '/settings-page');
  }

  Future<bool> _confirmRemoveFavorite(BuildContext context, int index) async {
    final property = _favoriteProperties[index];
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites?'),
        content: Text(
            'Are you sure you want to remove "${property['title']}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _removeFavorite(int index) async {
    final confirmed = await _confirmRemoveFavorite(context, index);
    if (confirmed && mounted) {
      // Start removal animation
      _animationController.forward(from: 0.0);

      // Remove the item with animation
      final removedItem = _favoriteProperties[index];
      setState(() {
        _favoriteProperties.removeAt(index);
      });

      // Show snackbar with undo option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Property removed from favorites'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _favoriteProperties.insert(index, removedItem);
              });
            },
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ViewToggleWidget(
            isGridView: _isGridView,
            onToggle: _toggleViewMode,
          ),
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'settings',
              size: 24,
            ),
            onPressed: _navigateToSettingsPage,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _favoriteProperties.isEmpty
              ? EmptyFavoritesWidget(onBrowseProperties: _navigateToHomePage)
              : _buildFavoritesList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Favorites tab
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateToHomePage();
              break;
            case 1:
              _navigateToSearchPage();
              break;
            case 2:
              // Already on favorites page
              break;
            case 3:
              _navigateToSettingsPage();
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: CustomIconWidget(iconName: 'home'),
            activeIcon: CustomIconWidget(iconName: 'home'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(iconName: 'search'),
            activeIcon: CustomIconWidget(iconName: 'search'),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(iconName: 'favorite'),
            activeIcon: CustomIconWidget(iconName: 'favorite'),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(iconName: 'person_outline'),
            activeIcon: CustomIconWidget(iconName: 'person'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildFavoritesList() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        key: const ValueKey<String>('favorites_grid'),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _favoriteProperties.length,
        itemBuilder: (context, index) {
          return FavoritePropertyCardWidget(
            property: _favoriteProperties[index],
            onTap: () =>
                _navigateToPropertyDetails(_favoriteProperties[index]['id']),
            onRemove: () => _removeFavorite(index),
            isGridView: true,
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        key: const ValueKey<String>('favorites_list'),
        itemCount: _favoriteProperties.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Dismissible(
              key: Key('favorite_${_favoriteProperties[index]['id']}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmRemoveFavorite(context, index),
              onDismissed: (_) {
                setState(() {
                  _favoriteProperties.removeAt(index);
                });
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                color: AppTheme.error,
                child: const CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.white,
                ),
              ),
              child: FavoritePropertyCardWidget(
                property: _favoriteProperties[index],
                onTap: () => _navigateToPropertyDetails(
                    _favoriteProperties[index]['id']),
                onRemove: () => _removeFavorite(index),
                isGridView: false,
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getMockFavoriteProperties() {
    return [
      {
        "id": 1,
        "title": "Luxury Villa with Private Pool",
        "address": "456 Palm Avenue, Beverly Hills, CA",
        "price": "\$3,200,000",
        "bedrooms": 5,
        "bathrooms": 4.5,
        "area": 4200,
        "type": "Villa",
        "isFavorite": true,
        "imageUrl":
            "https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bHV4dXJ5JTIwaG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
        "category": "Dream Homes",
      },
      {
        "id": 2,
        "title": "Waterfront Property with Dock",
        "address": "222 Lakeside Drive, Seattle, WA",
        "price": "\$1,750,000",
        "bedrooms": 4,
        "bathrooms": 3,
        "area": 3200,
        "type": "House",
        "isFavorite": true,
        "imageUrl":
            "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bHV4dXJ5JTIwaG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
        "category": "Investment Properties",
      },
      {
        "id": 3,
        "title": "Modern Penthouse with City Views",
        "address": "789 Skyline Avenue, Chicago, IL",
        "price": "\$2,100,000",
        "bedrooms": 3,
        "bathrooms": 3.5,
        "area": 2800,
        "type": "Apartment",
        "isFavorite": true,
        "imageUrl":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGx1eHVyeSUyMGhvdXNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
        "category": "Dream Homes",
      },
      {
        "id": 4,
        "title": "Beachfront Condo with Ocean Access",
        "address": "101 Coastal Way, Miami, FL",
        "price": "\$1,250,000",
        "bedrooms": 2,
        "bathrooms": 2,
        "area": 1800,
        "type": "Condo",
        "isFavorite": true,
        "imageUrl":
            "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8bHV4dXJ5JTIwaG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
        "category": "Vacation Homes",
      },
      {
        "id": 5,
        "title": "Historic Brownstone with Garden",
        "address": "555 Heritage Street, Boston, MA",
        "price": "\$1,850,000",
        "bedrooms": 4,
        "bathrooms": 3.5,
        "area": 3600,
        "type": "Townhouse",
        "isFavorite": true,
        "imageUrl":
            "https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJyb3duc3RvbmV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
        "category": "Investment Properties",
      },
    ];
  }
}
