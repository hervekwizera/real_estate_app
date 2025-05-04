import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/amenities_selector.dart';
import './widgets/form_section_header.dart';
import './widgets/form_step_indicator.dart';
import './widgets/location_picker_widget.dart';
import './widgets/numeric_stepper.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/property_type_selector.dart';
import './widgets/success_animation.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({Key? key}) : super(key: key);

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  late TabController _tabController;
  int _currentStep = 0;
  bool _isSaving = false;
  bool _isSubmitting = false;
  bool _showSuccess = false;

  // Form data
  final Map<String, dynamic> _propertyData = {
    "type": "",
    "title": "",
    "description": "",
    "price": "",
    'location': {
      "address": "",
      "city": "",
      "state": "",
      "zipCode": "",
      'coordinates': {'lat': 0.0, 'lng': 0.0},
    },
    'details': {
      'bedrooms': 1,
      'bathrooms': 1,
      'area': 0,
      'yearBuilt': DateTime.now().year,
    },
    'amenities': <String>[],
    'photos': <String>[],
    'contactInfo': {
      "name": "",
      "email": "",
      "phone": "",
    },
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  };

  // Form validation status
  final Map<int, bool> _stepValidationStatus = {
    0: false, // Basic Info
    1: false, // Details
    2: false, // Photos
    3: false, // Contact Info
  };

  // Step titles
  final List<String> _stepTitles = [
    'Basic Info',
    'Details',
    'Photos',
    'Contact Info',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentStep = _tabController.index;
        });
      }
    });

    // Auto-save timer setup would go here in a real app
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _tabController.animateTo(_currentStep);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitForm();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _tabController.animateTo(_currentStep);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveDraft() async {
    setState(() {
      _isSaving = true;
    });

    // Simulate saving to Firebase
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Show confirmation dialog
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Submit Property'),
          content:
              Text('Are you sure you want to submit this property listing?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Submit'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          _isSubmitting = true;
        });

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _isSubmitting = false;
          _showSuccess = true;
        });

        // Show success animation then navigate back
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-page');
        }
      }
    } else {
      // Find which step has validation errors
      for (int i = 0; i < 4; i++) {
        if (!_stepValidationStatus[i]!) {
          setState(() {
            _currentStep = i;
          });
          _tabController.animateTo(i);
          _pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          break;
        }
      }
    }
  }

  void _updateStepValidation(int step, bool isValid) {
    setState(() {
      _stepValidationStatus[step] = isValid;
    });
  }

  bool get _isFormValid => _stepValidationStatus.values.every((valid) => valid);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showSuccess) {
      return SuccessAnimation(
        message: 'Property Listed Successfully!',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
        leading: IconButton(
          icon: const CustomIconWidget(iconName: 'arrow_back'),
          onPressed: _goToPreviousStep,
        ),
        actions: [
          if (_currentStep > 0)
            IconButton(
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const CustomIconWidget(iconName: 'save'),
              onPressed: _isSaving ? null : _saveDraft,
              tooltip: 'Save Draft',
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Step indicator
              FormStepIndicator(
                currentStep: _currentStep,
                stepTitles: _stepTitles,
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                  _tabController.animateTo(step);
                  _pageController.animateToPage(
                    step,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),

              // Form content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                      _tabController.animateTo(index);
                    });
                  },
                  children: [
                    // Step 1: Basic Info
                    _buildBasicInfoStep(),

                    // Step 2: Details
                    _buildDetailsStep(),

                    // Step 3: Photos
                    _buildPhotosStep(),

                    // Step 4: Contact Info
                    _buildContactInfoStep(),
                  ],
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionHeader(title: 'Property Type'),
          const SizedBox(height: 16),
          PropertyTypeSelector(
            selectedType: _propertyData['type'],
            onTypeSelected: (type) {
              setState(() {
                _propertyData['type'] = type;
              });
              _validateBasicInfoStep();
            },
          ),
          const SizedBox(height: 24),
          FormSectionHeader(title: 'Property Title'),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter a descriptive title',
              prefixIcon: CustomIconWidget(iconName: 'title'),
            ),
            textCapitalization: TextCapitalization.words,
            maxLength: 100,
            onChanged: (value) {
              _propertyData['title'] = value;
              _validateBasicInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              if (value.length < 10) {
                return 'Title should be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FormSectionHeader(title: 'Price'),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter property price',
              prefixIcon: CustomIconWidget(iconName: 'attach_money'),
              prefixText: '\$ ',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              _propertyData['price'] = value;
              _validateBasicInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FormSectionHeader(title: 'Location'),
          const SizedBox(height: 16),
          LocationPickerWidget(
            initialLocation: _propertyData['location'],
            onLocationSelected: (location) {
              setState(() {
                _propertyData['location'] = location;
              });
              _validateBasicInfoStep();
            },
          ),
          const SizedBox(height: 24),
          FormSectionHeader(title: 'Description'),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Describe your property',
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              _propertyData['description'] = value;
              _validateBasicInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              if (value.length < 50) {
                return 'Description should be at least 50 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionHeader(title: 'Property Specifications'),
          const SizedBox(height: 24),

          // Bedrooms
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'bed',
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Bedrooms',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              NumericStepper(
                value: _propertyData['details']['bedrooms'],
                min: 0,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    _propertyData['details']['bedrooms'] = value;
                  });
                  _validateDetailsStep();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Bathrooms
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'bathtub',
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Bathrooms',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              NumericStepper(
                value: _propertyData['details']['bathrooms'],
                min: 0,
                max: 10,
                allowHalf: true,
                onChanged: (value) {
                  setState(() {
                    _propertyData['details']['bathrooms'] = value;
                  });
                  _validateDetailsStep();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Area
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'square_foot',
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Area (sq ft)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Area',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    suffixText: 'sq ft',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    _propertyData['details']['area'] = int.tryParse(value) ?? 0;
                    _validateDetailsStep();
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
          const Divider(),
          const SizedBox(height: 16),

          // Year Built
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'calendar_today',
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Year Built',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Year',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  initialValue:
                      _propertyData['details']['yearBuilt'].toString(),
                  onChanged: (value) {
                    _propertyData['details']['yearBuilt'] =
                        int.tryParse(value) ?? DateTime.now().year;
                    _validateDetailsStep();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final year = int.tryParse(value);
                    if (year == null ||
                        year < 1800 ||
                        year > DateTime.now().year) {
                      return 'Invalid year';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          FormSectionHeader(title: 'Amenities'),
          const SizedBox(height: 16),
          AmenitiesSelector(
            selectedAmenities: _propertyData['amenities'],
            onAmenitiesChanged: (amenities) {
              setState(() {
                _propertyData['amenities'] = amenities;
              });
              _validateDetailsStep();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionHeader(
            title: 'Property Photos',
            subtitle:
                'Add up to 10 photos of your property. The first photo will be used as the cover image.',
          ),
          const SizedBox(height: 24),
          PhotoUploadWidget(
            photos: _propertyData['photos'],
            onPhotosChanged: (photos) {
              setState(() {
                _propertyData['photos'] = photos;
              });
              _validatePhotosStep();
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Tips for great property photos:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildPhotoTip('Use natural lighting when possible'),
          _buildPhotoTip('Capture all rooms and key features'),
          _buildPhotoTip('Keep the camera level for straight horizons'),
          _buildPhotoTip('Remove clutter before taking photos'),
          _buildPhotoTip('Include exterior shots and surroundings'),
        ],
      ),
    );
  }

  Widget _buildPhotoTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomIconWidget(
            iconName: 'check_circle',
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionHeader(
            title: 'Contact Information',
            subtitle:
                'Provide your contact details for interested buyers or renters.',
          ),
          const SizedBox(height: 24),

          // Name
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: CustomIconWidget(iconName: 'person'),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              _propertyData['contactInfo']['name'] = value;
              _validateContactInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: CustomIconWidget(iconName: 'email'),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              _propertyData['contactInfo']['email'] = value;
              _validateContactInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Phone
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: CustomIconWidget(iconName: 'phone'),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              _propertyData['contactInfo']['phone'] = value;
              _validateContactInfoStep();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Privacy notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomIconWidget(
                      iconName: 'privacy_tip',
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Privacy Notice',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Your contact information will be visible to users interested in your property. We respect your privacy and will not share your information with third parties.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final theme = Theme.of(context);
    final isLastStep = _currentStep == 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: _goToPreviousStep,
              icon: const CustomIconWidget(iconName: 'arrow_back'),
              label: const Text('Back'),
            )
          else
            const SizedBox.shrink(),
          Expanded(
            child: Align(
              alignment:
                  _currentStep > 0 ? Alignment.centerRight : Alignment.center,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _goToNextStep,
                icon: _isSubmitting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: isLastStep ? 'check' : 'arrow_forward',
                      ),
                label: Text(isLastStep ? 'Submit' : 'Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateBasicInfoStep() {
    final isTypeSelected = _propertyData['type'].isNotEmpty;
    final isTitleValid = _propertyData['title'].length >= 10;
    final isPriceValid = _propertyData['price'].isNotEmpty;
    final isLocationValid = _propertyData['location']['address'].isNotEmpty;
    final isDescriptionValid = _propertyData['description'].length >= 50;

    _updateStepValidation(
        0,
        isTypeSelected &&
            isTitleValid &&
            isPriceValid &&
            isLocationValid &&
            isDescriptionValid);
  }

  void _validateDetailsStep() {
    final isAreaValid = _propertyData['details']['area'] > 0;
    final isYearBuiltValid = _propertyData['details']['yearBuilt'] >= 1800 &&
        _propertyData['details']['yearBuilt'] <= DateTime.now().year;

    _updateStepValidation(1, isAreaValid && isYearBuiltValid);
  }

  void _validatePhotosStep() {
    final hasPhotos = _propertyData['photos'].isNotEmpty;

    _updateStepValidation(2, hasPhotos);
  }

  void _validateContactInfoStep() {
    final isNameValid = _propertyData['contactInfo']['name'].isNotEmpty;
    final isEmailValid = _propertyData['contactInfo']['email'].isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_propertyData['contactInfo']['email']);
    final isPhoneValid = _propertyData['contactInfo']['phone'].isNotEmpty;

    _updateStepValidation(3, isNameValid && isEmailValid && isPhoneValid);
  }
}
