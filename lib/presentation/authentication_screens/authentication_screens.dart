import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/auth_button_widget.dart';
import './widgets/auth_text_field_widget.dart';
import './widgets/password_strength_indicator_widget.dart';
import './widgets/social_login_button_widget.dart';

class AuthenticationScreens extends StatefulWidget {
  const AuthenticationScreens({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreens> createState() => _AuthenticationScreensState();
}

class _AuthenticationScreensState extends State<AuthenticationScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  final _formKeyReset = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _emailLoginController = TextEditingController();
  final TextEditingController _passwordLoginController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailResetController = TextEditingController();

  bool _obscurePasswordLogin = true;
  bool _obscurePasswordRegister = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _resetEmailSent = false;

  String _passwordStrength = '';
  double _passwordStrengthScore = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to password changes to update strength indicator
    _passwordRegisterController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailLoginController.dispose();
    _passwordLoginController.dispose();
    _nameController.dispose();
    _emailRegisterController.dispose();
    _passwordRegisterController.dispose();
    _confirmPasswordController.dispose();
    _emailResetController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final password = _passwordRegisterController.text;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordStrengthScore = 0.0;
      });
      return;
    }

    // Calculate password strength
    double score = 0.0;
    String strength = 'Weak';

    if (password.length >= 8) score += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) score += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) score += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 0.25;

    if (score > 0.75) {
      strength = 'Strong';
    } else if (score > 0.5) {
      strength = 'Medium';
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthScore = score;
    });
  }

  void _togglePasswordVisibilityLogin() {
    setState(() {
      _obscurePasswordLogin = !_obscurePasswordLogin;
    });
  }

  void _togglePasswordVisibilityRegister() {
    setState(() {
      _obscurePasswordRegister = !_obscurePasswordRegister;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKeyLogin.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock credentials check
      if (_emailLoginController.text == 'user@example.com' &&
          _passwordLoginController.text == 'Password123!') {
        // Navigate to home page on successful login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-page');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_formKeyRegister.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms of Service'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please log in.'),
            backgroundColor: AppTheme.success,
          ),
        );

        // Clear form and switch to login tab
        _nameController.clear();
        _emailRegisterController.clear();
        _passwordRegisterController.clear();
        _confirmPasswordController.clear();
        _agreeToTerms = false;
        _tabController.animateTo(0);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_formKeyReset.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _resetEmailSent = true;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider login successful!'),
          backgroundColor: AppTheme.success,
        ),
      );

      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home-page');
    }
  }

  void _resetPasswordForm() {
    setState(() {
      _resetEmailSent = false;
      _emailResetController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          // App Logo
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'home',
                                size: 48,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Real Estate App',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Find your dream property',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Tab Bar
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: theme.colorScheme.primary,
                              unselectedLabelColor:
                                  theme.colorScheme.onSurfaceVariant,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? AppTheme.shadowDark
                                            .withValues(alpha: 0.1)
                                        : AppTheme.shadowLight
                                            .withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'Login'),
                                Tab(text: 'Register'),
                                Tab(text: 'Reset'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Tab Content
                          SizedBox(
                            height: 500, // Adjust based on content
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Login Tab
                                _buildLoginTab(),

                                // Register Tab
                                _buildRegisterTab(),

                                // Reset Password Tab
                                _buildResetPasswordTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Loading Overlay
              if (_isLoading)
                Container(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    final theme = Theme.of(context);

    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          AuthTextFieldWidget(
            controller: _emailLoginController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: 'email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password Field
          AuthTextFieldWidget(
            controller: _passwordLoginController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: 'lock',
            obscureText: _obscurePasswordLogin,
            suffixIcon: _obscurePasswordLogin ? 'visibility' : 'visibility_off',
            onSuffixIconTap: _togglePasswordVisibilityLogin,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'Remember me',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(2);
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Login Button
          AuthButtonWidget(
            text: 'Login',
            onPressed: _handleLogin,
          ),

          const SizedBox(height: 24),

          // Divider with "Or" text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Or continue with',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Social Login Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialLoginButtonWidget(
                iconName: 'g_logo',
                text: 'Google',
                onPressed: () => _handleSocialLogin('Google'),
              ),
              const SizedBox(width: 16),
              SocialLoginButtonWidget(
                iconName: 'facebook',
                text: 'Facebook',
                onPressed: () => _handleSocialLogin('Facebook'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Register Prompt
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () {
                  _tabController.animateTo(1);
                },
                child: Text(
                  'Register',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    final theme = Theme.of(context);

    return Form(
      key: _formKeyRegister,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          AuthTextFieldWidget(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: 'person',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Email Field
          AuthTextFieldWidget(
            controller: _emailRegisterController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: 'email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password Field
          AuthTextFieldWidget(
            controller: _passwordRegisterController,
            labelText: 'Password',
            hintText: 'Create a password',
            prefixIcon: 'lock',
            obscureText: _obscurePasswordRegister,
            suffixIcon:
                _obscurePasswordRegister ? 'visibility' : 'visibility_off',
            onSuffixIconTap: _togglePasswordVisibilityRegister,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Password must contain at least one number';
              }
              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                return 'Password must contain at least one special character';
              }
              return null;
            },
          ),

          if (_passwordRegisterController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PasswordStrengthIndicatorWidget(
                strength: _passwordStrength,
                score: _passwordStrengthScore,
              ),
            ),

          const SizedBox(height: 16),

          // Confirm Password Field
          AuthTextFieldWidget(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            prefixIcon: 'lock',
            obscureText: _obscureConfirmPassword,
            suffixIcon:
                _obscureConfirmPassword ? 'visibility' : 'visibility_off',
            onSuffixIconTap: _toggleConfirmPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordRegisterController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Terms and Conditions
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'I agree to the ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Register Button
          AuthButtonWidget(
            text: 'Register',
            onPressed: _handleRegister,
          ),

          const SizedBox(height: 24),

          // Login Prompt
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () {
                  _tabController.animateTo(0);
                },
                child: Text(
                  'Login',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordTab() {
    final theme = Theme.of(context);

    if (_resetEmailSent) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.successLight,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CustomIconWidget(
                iconName: 'check_circle',
                size: 48,
                color: AppTheme.success,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Reset Email Sent!',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'We have sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          AuthButtonWidget(
            text: 'Back to Login',
            onPressed: () {
              _resetPasswordForm();
              _tabController.animateTo(0);
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _resetPasswordForm,
            child: Text('Try Again'),
          ),
        ],
      );
    }

    return Form(
      key: _formKeyReset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forgot your password?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Email Field
          AuthTextFieldWidget(
            controller: _emailResetController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: 'email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Reset Button
          AuthButtonWidget(
            text: 'Send Reset Link',
            onPressed: _handleResetPassword,
          ),

          const SizedBox(height: 24),

          // Back to Login
          Center(
            child: TextButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              child: Text('Back to Login'),
            ),
          ),
        ],
      ),
    );
  }
}
