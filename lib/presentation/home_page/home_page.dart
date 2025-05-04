import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/category_selector_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _properties = [];
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'House',
    'Apartment',
    'Villa',
    'Office'
  ];
  final List<String> _filterOptions = [
    'Price',
    'Bedrooms',
    'Bathrooms',
    'Area'
  ];

  @override
  void initState() {
    super.initState();
    _loadProperties();

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreProperties();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _properties = _getMockProperties();
      _isLoading = false;
    });
  }

  Future<void> _refreshProperties() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _properties = _getMockProperties();
      _isRefreshing = false;
    });
  }

  Future<void> _loadMoreProperties() async {
    // Simulate loading more properties
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _properties.addAll(_getMockProperties().take(3));
    });
  }

  void _navigateToPropertyDetails(int propertyId) {
    Navigator.pushNamed(context, AppRoutes.propertyDetailsPage,
        arguments: {'propertyId': propertyId});
  }

  void _navigateToSearchPage() {
    Navigator.pushNamed(context, AppRoutes.searchPage);
  }

  void _navigateToAddPropertyPage() {
    Navigator.pushNamed(context, AppRoutes.addPropertyPage);
  }

  void _navigateToFavoritesPage() {
    Navigator.pushNamed(context, AppRoutes.favoritesPage);
  }

  void _navigateToSettingsPage() {
    Navigator.pushNamed(context, AppRoutes.settingsPage);
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      // In a real app, you would filter properties based on category
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Real Estate',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'favorite_border',
              size: 24,
            ),
            onPressed: _navigateToFavoritesPage,
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
      body: RefreshIndicator(
        onRefresh: _refreshProperties,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBarWidget(onTap: _navigateToSearchPage),
                    const SizedBox(height: 16),
                    Text(
                      'Categories',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    CategorySelectorWidget(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: _onCategorySelected,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Properties',
                          style: theme.textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: _navigateToSearchPage,
                          child: Text(
                            'See All',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filterOptions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChipWidget(
                              label: _filterOptions[index],
                              onTap: () {
                                // Show filter dialog
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _isLoading
                ? SliverFillRemaining(
                    child: _buildSkeletonLoader(),
                  )
                : _properties.isEmpty
                    ? SliverFillRemaining(
                        child: _buildEmptyState(),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == _properties.length) {
                                return _buildLoadingIndicator();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: PropertyCardWidget(
                                  property: _properties[index],
                                  onTap: () => _navigateToPropertyDetails(
                                      _properties[index]['id']),
                                  onFavoriteToggle: (bool isFavorite) {
                                    // Update favorite status
                                    setState(() {
                                      _properties[index]['isFavorite'] =
                                          isFavorite;
                                    });
                                  },
                                ),
                              );
                            },
                            childCount: _properties.length + 1,
                          ),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPropertyPage,
        tooltip: 'Add Property',
        child: const CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home page
              break;
            case 1:
              _navigateToSearchPage();
              break;
            case 2:
              _navigateToFavoritesPage();
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
            icon: CustomIconWidget(iconName: 'favorite_border'),
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

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 16,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          3,
                          (i) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 2 ? 8.0 : 0),
                              child: Container(
                                height: 24,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'home_work',
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Properties Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProperties,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  List<Map<String, dynamic>> _getMockProperties() {
    return [
      {
        "id": 1,
        "title": "Modern Apartment with Ocean View",
        "address": "123 Coastal Drive, Miami, FL",
        "price": "\$850,000",
        "bedrooms": 3,
        "bathrooms": 2,
        "area": 1850,
        "type": "Apartment",
        "isFavorite": false,
        "imageUrl":
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHJlYWwlMjBlc3RhdGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 2,
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
      },
      {
        "id": 3,
        "title": "Cozy Suburban Family Home",
        "address": "789 Maple Street, Portland, OR",
        "price": "\$525,000",
        "bedrooms": 4,
        "bathrooms": 2.5,
        "area": 2100,
        "type": "House",
        "isFavorite": false,
        "imageUrl":
            "https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8aG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 4,
        "title": "Downtown Loft with City Views",
        "address": "101 Urban Street, New York, NY",
        "price": "\$1,150,000",
        "bedrooms": 2,
        "bathrooms": 2,
        "area": 1600,
        "type": "Apartment",
        "isFavorite": false,
        "imageUrl":
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YXBhcnRtZW50fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 5,
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
      },
      {
        "id": 6,
        "title": "Modern Office Space",
        "address": "333 Business Park, Chicago, IL",
        "price": "\$950,000",
        "bedrooms": 0,
        "bathrooms": 2,
        "area": 2800,
        "type": "Office",
        "isFavorite": false,
        "imageUrl":
            "https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8b2ZmaWNlJTIwc3BhY2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      },
    ];
  }
}
