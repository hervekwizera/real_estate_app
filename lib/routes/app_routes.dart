import 'package:flutter/material.dart';
import '../presentation/home_page/home_page.dart';
import '../presentation/favorites_page/favorites_page.dart';
import '../presentation/settings_page/settings_page.dart';
import '../presentation/property_details_page/property_details_page.dart';
import '../presentation/onboarding_screens/onboarding_screens.dart';
import '../presentation/search_page/search_page.dart';
import '../presentation/add_property_page/add_property_page.dart';
import '../presentation/authentication_screens/authentication_screens.dart';

class AppRoutes {
  static const String homePage = '/home-page';
  static const String propertyDetailsPage = '/property-details-page';
  static const String searchPage = '/search-page';
  static const String addPropertyPage = '/add-property-page';
  static const String favoritesPage = '/favorites-page';
  static const String settingsPage = '/settings-page';
  static const String onboardingScreens = '/onboarding-screens';
  static const String authenticationScreens = '/authentication-screens';
  static const String initial = homePage;

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case propertyDetailsPage:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PropertyDetailsPage(propertyId: args?['propertyId']),
        );
      case searchPage:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
        );
      case addPropertyPage:
        return MaterialPageRoute(
          builder: (_) => const AddPropertyPage(),
        );
      case favoritesPage:
        return MaterialPageRoute(
          builder: (_) => const FavoritesPage(),
        );
      case settingsPage:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      case onboardingScreens:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreens(),
        );
      case authenticationScreens:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationScreens(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
