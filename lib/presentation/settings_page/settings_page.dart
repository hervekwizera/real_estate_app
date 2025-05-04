import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_tile_widget.dart';
import './widgets/theme_selector_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  // User preferences
  bool _newListingsNotifications = true;
  bool _priceChangesNotifications = true;
  bool _messagesNotifications = true;
  String _selectedTheme = 'system';
  String _viewPreference = 'grid';
  String _currencyFormat = 'USD';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Alex Johnson",
    "email": "alex.johnson@example.com",
    "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
  };

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _newListingsNotifications =
          prefs.getBool('newListingsNotifications') ?? true;
      _priceChangesNotifications =
          prefs.getBool('priceChangesNotifications') ?? true;
      _messagesNotifications = prefs.getBool('messagesNotifications') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'system';
      _viewPreference = prefs.getString('viewPreference') ?? 'grid';
      _currencyFormat = prefs.getString('currencyFormat') ?? 'USD';
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }

    // Animate save confirmation
    _animationController.forward(from: 0.0);
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content:
            const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'This action cannot be undone. All your data will be permanently deleted. Are you sure you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // In a real app, you would clear auth tokens, user session, etc.
    Navigator.pushReplacementNamed(context, '/authentication-screens');
  }

  void _handleDeleteAccount() {
    // In a real app, you would call an API to delete the user's account
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
    Navigator.pushReplacementNamed(context, '/authentication-screens');
  }

  void _navigateToEditProfile() {
    // In a real app, you would navigate to the edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile feature coming soon')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Real Estate App',
        applicationVersion: 'v1.0.0',
        applicationIcon: const CustomIconWidget(
          iconName: 'home_work',
          size: 48,
          color: AppTheme.primary600,
        ),
        applicationLegalese: '© 2023 Real Estate App. All rights reserved.',
        children: [
          const SizedBox(height: 16),
          const Text(
            'A modern real estate application for finding your dream home.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const CustomIconWidget(iconName: 'arrow_back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Section
              ProfileHeaderWidget(
                userData: _userData,
                onEditProfile: _navigateToEditProfile,
              ),
              const SizedBox(height: 24),

              // Account Section
              SettingsSectionWidget(
                title: 'Account',
                children: [
                  SettingsTileWidget(
                    title: 'Edit Profile',
                    subtitle: 'Change your personal information',
                    leading: const CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: _navigateToEditProfile,
                  ),
                  SettingsTileWidget(
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    leading: const CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Change Password feature coming soon')),
                      );
                    },
                  ),
                  SettingsTileWidget(
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    leading: const CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.warning,
                    ),
                    onTap: _showLogoutConfirmation,
                  ),
                  SettingsTileWidget(
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your account and data',
                    leading: const CustomIconWidget(
                      iconName: 'delete_forever',
                      color: AppTheme.error,
                    ),
                    onTap: _showDeleteAccountConfirmation,
                    isDestructive: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Notifications Section
              SettingsSectionWidget(
                title: 'Notifications',
                children: [
                  SettingsTileWidget(
                    title: 'New Listings',
                    subtitle: 'Get notified about new properties',
                    leading: const CustomIconWidget(
                      iconName: 'notifications',
                      color: AppTheme.primary600,
                    ),
                    trailing: Switch(
                      value: _newListingsNotifications,
                      onChanged: (value) {
                        setState(() {
                          _newListingsNotifications = value;
                        });
                        _savePreference('newListingsNotifications', value);
                      },
                    ),
                  ),
                  SettingsTileWidget(
                    title: 'Price Changes',
                    subtitle: 'Get notified about price updates',
                    leading: const CustomIconWidget(
                      iconName: 'price_change',
                      color: AppTheme.primary600,
                    ),
                    trailing: Switch(
                      value: _priceChangesNotifications,
                      onChanged: (value) {
                        setState(() {
                          _priceChangesNotifications = value;
                        });
                        _savePreference('priceChangesNotifications', value);
                      },
                    ),
                  ),
                  SettingsTileWidget(
                    title: 'Messages',
                    subtitle: 'Get notified about new messages',
                    leading: const CustomIconWidget(
                      iconName: 'message',
                      color: AppTheme.primary600,
                    ),
                    trailing: Switch(
                      value: _messagesNotifications,
                      onChanged: (value) {
                        setState(() {
                          _messagesNotifications = value;
                        });
                        _savePreference('messagesNotifications', value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Appearance Section
              SettingsSectionWidget(
                title: 'Appearance',
                children: [
                  ThemeSelectorWidget(
                    selectedTheme: _selectedTheme,
                    onThemeChanged: (value) {
                      setState(() {
                        _selectedTheme = value;
                      });
                      _savePreference('theme', value);
                    },
                  ),
                  SettingsTileWidget(
                    title: 'View Preference',
                    subtitle: 'Choose how properties are displayed',
                    leading: const CustomIconWidget(
                      iconName: 'view_module',
                      color: AppTheme.primary600,
                    ),
                    trailing: DropdownButton<String>(
                      value: _viewPreference,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'grid',
                          child: Text('Grid View'),
                        ),
                        DropdownMenuItem(
                          value: 'list',
                          child: Text('List View'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _viewPreference = value;
                          });
                          _savePreference('viewPreference', value);
                        }
                      },
                    ),
                  ),
                  SettingsTileWidget(
                    title: 'Currency Format',
                    subtitle: 'Choose your preferred currency',
                    leading: const CustomIconWidget(
                      iconName: 'attach_money',
                      color: AppTheme.primary600,
                    ),
                    trailing: DropdownButton<String>(
                      value: _currencyFormat,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'USD',
                          child: Text('USD (\$)'),
                        ),
                        DropdownMenuItem(
                          value: 'EUR',
                          child: Text('EUR (€)'),
                        ),
                        DropdownMenuItem(
                          value: 'GBP',
                          child: Text('GBP (£)'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _currencyFormat = value;
                          });
                          _savePreference('currencyFormat', value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Support Section
              SettingsSectionWidget(
                title: 'Support',
                children: [
                  SettingsTileWidget(
                    title: 'Help Center',
                    subtitle: 'Get help with using the app',
                    leading: const CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Help Center feature coming soon')),
                      );
                    },
                  ),
                  SettingsTileWidget(
                    title: 'Contact Us',
                    subtitle: 'Get in touch with our support team',
                    leading: const CustomIconWidget(
                      iconName: 'support_agent',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Contact Us feature coming soon')),
                      );
                    },
                  ),
                  SettingsTileWidget(
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    leading: const CustomIconWidget(
                      iconName: 'policy',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Privacy Policy feature coming soon')),
                      );
                    },
                  ),
                  SettingsTileWidget(
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    leading: const CustomIconWidget(
                      iconName: 'description',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Terms of Service feature coming soon')),
                      );
                    },
                  ),
                  SettingsTileWidget(
                    title: 'About',
                    subtitle: 'Learn more about the app',
                    leading: const CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.primary600,
                    ),
                    trailing: const CustomIconWidget(iconName: 'chevron_right'),
                    onTap: _showAboutDialog,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // App Version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),

          // Save confirmation animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final value = _animationController.value;
              return Positioned(
                top: 16,
                right: 16,
                child: Opacity(
                  opacity: value > 0.5 ? 1.0 - (value - 0.5) * 2 : value * 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Saved',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Settings is the 4th tab (index 3)
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-page');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search-page');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/favorites-page');
              break;
            case 3:
              // Already on settings page
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
            icon: CustomIconWidget(iconName: 'settings'),
            activeIcon: CustomIconWidget(iconName: 'settings'),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
