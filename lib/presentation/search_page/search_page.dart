import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_filters_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/price_range_slider_widget.dart';
import './widgets/property_grid_item_widget.dart';
import './widgets/property_list_item_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_history_item_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isGridView = true;
  bool _showAdvancedFilters = false;
  bool _showSearchHistory = false;
  bool _showLocationSuggestions = false;

  RangeValues _priceRange = const RangeValues(100000, 1000000);
  String _selectedPropertyType = 'All';
  int _selectedBedrooms = 0;
  int _selectedBathrooms = 0;
  List<String> _selectedAmenities = [];

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _searchHistory = [
    'Miami Beach apartments',
    'Houses in Portland under \$500k',
    'New York lofts',
    'Waterfront properties Seattle'
  ];

  List<String> _locationSuggestions = [
    'Miami, FL',
    'Miami Beach, FL',
    'Miami Gardens, FL',
    'Miami Lakes, FL',
    'Miami Shores, FL'
  ];

  final List<String> _propertyTypes = [
    'All',
    'House',
    'Apartment',
    'Villa',
    'Office',
    'Land'
  ];
  final List<String> _amenities = [
    'Swimming Pool',
    'Garden',
    'Garage',
    'Balcony',
    'Gym',
    'Security',
    'Elevator',
    'Air Conditioning',
    'Furnished'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialResults();

    _searchFocusNode.addListener(() {
      setState(() {
        _showSearchHistory =
            _searchFocusNode.hasFocus && _searchController.text.isEmpty;
        _showLocationSuggestions =
            _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });

    _searchController.addListener(() {
      setState(() {
        _showLocationSuggestions =
            _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialResults() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _searchResults = _getMockProperties();
        _isLoading = false;
      });
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSearchHistory = false;
      _showLocationSuggestions = false;
    });

    // Add to search history if not already present
    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      });
    }

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Filter mock properties based on query
        _searchResults = _getMockProperties().where((property) {
          return property['title']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              property['address'].toLowerCase().contains(query.toLowerCase()) ||
              property['type'].toLowerCase().contains(query.toLowerCase());
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        // Filter mock properties based on all filters
        _searchResults = _getMockProperties().where((property) {
          final double price = _extractPrice(property['price']);
          final bool priceInRange =
              price >= _priceRange.start && price <= _priceRange.end;

          final bool typeMatches = _selectedPropertyType == 'All' ||
              property['type'] == _selectedPropertyType;

          final bool bedroomsMatch = _selectedBedrooms == 0 ||
              property['bedrooms'] >= _selectedBedrooms;

          final bool bathroomsMatch = _selectedBathrooms == 0 ||
              property['bathrooms'] >= _selectedBathrooms;

          bool amenitiesMatch = true;
          if (_selectedAmenities.isNotEmpty) {
            amenitiesMatch = _selectedAmenities.every((amenity) =>
                property['amenities'] != null &&
                property['amenities'].contains(amenity));
          }

          return priceInRange &&
              typeMatches &&
              bedroomsMatch &&
              bathroomsMatch &&
              amenitiesMatch;
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(100000, 1000000);
      _selectedPropertyType = 'All';
      _selectedBedrooms = 0;
      _selectedBathrooms = 0;
      _selectedAmenities = [];
      _searchController.clear();
    });

    _applyFilters();
  }

  void _navigateToPropertyDetails(int propertyId) {
    Navigator.pushNamed(context, '/property-details-page',
        arguments: {'propertyId': propertyId});
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _toggleAdvancedFilters() {
    setState(() {
      _showAdvancedFilters = !_showAdvancedFilters;
    });
  }

  void _selectLocationSuggestion(String location) {
    setState(() {
      _searchController.text = location;
      _showLocationSuggestions = false;
    });
    _performSearch(location);
  }

  void _selectSearchHistoryItem(String query) {
    setState(() {
      _searchController.text = query;
      _showSearchHistory = false;
    });
    _performSearch(query);
  }

  void _updatePriceRange(RangeValues values) {
    setState(() {
      _priceRange = values;
    });
  }

  void _updatePropertyType(String type) {
    setState(() {
      _selectedPropertyType = type;
    });
  }

  void _updateBedrooms(int bedrooms) {
    setState(() {
      _selectedBedrooms = bedrooms;
    });
  }

  void _updateBathrooms(int bathrooms) {
    setState(() {
      _selectedBathrooms = bathrooms;
    });
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_selectedAmenities.contains(amenity)) {
        _selectedAmenities.remove(amenity);
      } else {
        _selectedAmenities.add(amenity);
      }
    });
  }

  double _extractPrice(String priceString) {
    // Remove currency symbol and commas, then parse to double
    return double.parse(priceString.replaceAll('\$', '').replaceAll(',', ''));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Properties',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
          ),
          onPressed: () => Navigator.pushNamed(context, '/home-page'),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isGridView ? 'view_list' : 'grid_view',
            ),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard and suggestions when tapping outside
          FocusScope.of(context).unfocus();
          setState(() {
            _showSearchHistory = false;
            _showLocationSuggestions = false;
          });
        },
        child: Column(
          children: [
            // Search bar and filters section
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  SearchBarWidget(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onSearch: _performSearch,
                  ),

                  const SizedBox(height: 16),

                  // Price range slider
                  Text(
                    'Price Range',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  PriceRangeSliderWidget(
                    currentRange: _priceRange,
                    min: 50000,
                    max: 5000000,
                    onChanged: _updatePriceRange,
                    onChangeEnd: (_) => _applyFilters(),
                  ),

                  const SizedBox(height: 16),

                  // Quick filters
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _propertyTypes.map((type) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChipWidget(
                                  label: type,
                                  isSelected: _selectedPropertyType == type,
                                  onTap: () {
                                    _updatePropertyType(type);
                                    _applyFilters();
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _toggleAdvancedFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _showAdvancedFilters
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'More Filters',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _showAdvancedFilters
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              CustomIconWidget(
                                iconName: _showAdvancedFilters
                                    ? 'expand_less'
                                    : 'expand_more',
                                size: 16,
                                color: _showAdvancedFilters
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Advanced filters (expandable)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showAdvancedFilters ? null : 0,
                    child: _showAdvancedFilters
                        ? AdvancedFiltersWidget(
                            selectedBedrooms: _selectedBedrooms,
                            selectedBathrooms: _selectedBathrooms,
                            selectedAmenities: _selectedAmenities,
                            amenitiesList: _amenities,
                            onBedroomsChanged: (value) {
                              _updateBedrooms(value);
                              _applyFilters();
                            },
                            onBathroomsChanged: (value) {
                              _updateBathrooms(value);
                              _applyFilters();
                            },
                            onAmenityToggled: (amenity) {
                              _toggleAmenity(amenity);
                              _applyFilters();
                            },
                            onResetFilters: _resetFilters,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Search history suggestions
            if (_showSearchHistory)
              Container(
                color: theme.colorScheme.surface,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        'Recent Searches',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchHistory.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return SearchHistoryItemWidget(
                          query: _searchHistory[index],
                          onTap: () =>
                              _selectSearchHistoryItem(_searchHistory[index]),
                          onDelete: () {
                            setState(() {
                              _searchHistory.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Location suggestions
            if (_showLocationSuggestions)
              Container(
                color: theme.colorScheme.surface,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        'Suggestions',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _locationSuggestions
                          .where((location) => location
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final filteredSuggestions = _locationSuggestions
                            .where((location) => location
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                            .toList();

                        if (index < filteredSuggestions.length) {
                          return ListTile(
                            leading: const CustomIconWidget(
                              iconName: 'location_on',
                              size: 20,
                            ),
                            title: Text(filteredSuggestions[index]),
                            onTap: () => _selectLocationSuggestion(
                                filteredSuggestions[index]),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

            // Results count and loading indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  if (_isLoading)
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Searching...',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    )
                  else
                    Text(
                      '${_searchResults.length} properties found',
                      style: theme.textTheme.bodyMedium,
                    ),
                  const Spacer(),
                  if (_searchResults.isNotEmpty && !_isLoading)
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text('Reset Filters'),
                    ),
                ],
              ),
            ),

            // Search results
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : _isGridView
                          ? _buildGridView()
                          : _buildListView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home-page');
              break;
            case 1:
              // Already on search page
              break;
            case 2:
              Navigator.pushNamed(context, '/favorites-page');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings-page');
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Searching for properties...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search for a different location',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetFilters,
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return PropertyGridItemWidget(
          property: _searchResults[index],
          onTap: () => _navigateToPropertyDetails(_searchResults[index]['id']),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return PropertyListItemWidget(
          property: _searchResults[index],
          onTap: () => _navigateToPropertyDetails(_searchResults[index]['id']),
        );
      },
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
        "amenities": ["Balcony", "Swimming Pool", "Gym", "Security"],
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
        "amenities": [
          "Swimming Pool",
          "Garden",
          "Garage",
          "Security",
          "Air Conditioning"
        ],
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
        "amenities": ["Garden", "Garage", "Air Conditioning"],
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
        "amenities": ["Elevator", "Security", "Air Conditioning"],
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
        "amenities": ["Swimming Pool", "Garden", "Garage", "Air Conditioning"],
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
        "amenities": ["Elevator", "Security", "Air Conditioning"],
        "imageUrl":
            "https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8b2ZmaWNlJTIwc3BhY2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 7,
        "title": "Beachfront Condo",
        "address": "555 Ocean Drive, Miami Beach, FL",
        "price": "\$1,250,000",
        "bedrooms": 2,
        "bathrooms": 2,
        "area": 1400,
        "type": "Apartment",
        "isFavorite": false,
        "amenities": [
          "Swimming Pool",
          "Balcony",
          "Gym",
          "Security",
          "Air Conditioning"
        ],
        "imageUrl":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGhvdXNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 8,
        "title": "Mountain Retreat Cabin",
        "address": "777 Pine Trail, Aspen, CO",
        "price": "\$875,000",
        "bedrooms": 3,
        "bathrooms": 2,
        "area": 1800,
        "type": "House",
        "isFavorite": true,
        "amenities": ["Furnished", "Garden", "Air Conditioning"],
        "imageUrl":
            "https://images.unsplash.com/photo-1518780664697-55e3ad937233?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 9,
        "title": "Penthouse with Rooftop Terrace",
        "address": "999 Skyline Avenue, San Francisco, CA",
        "price": "\$2,950,000",
        "bedrooms": 3,
        "bathrooms": 3.5,
        "area": 2600,
        "type": "Apartment",
        "isFavorite": false,
        "amenities": ["Balcony", "Elevator", "Security", "Air Conditioning"],
        "imageUrl":
            "https://images.unsplash.com/photo-1493246318656-5bfd4cfb29b8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fHBlbnRob3VzZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
      },
      {
        "id": 10,
        "title": "Historic Brownstone",
        "address": "123 Heritage Row, Boston, MA",
        "price": "\$1,850,000",
        "bedrooms": 4,
        "bathrooms": 3,
        "area": 3000,
        "type": "House",
        "isFavorite": false,
        "amenities": ["Garden", "Furnished", "Air Conditioning"],
        "imageUrl":
            "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YnJvd25zdG9uZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
      },
    ];
  }
}
