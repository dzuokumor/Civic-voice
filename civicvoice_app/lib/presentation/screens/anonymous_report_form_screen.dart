import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/app_localizations.dart';
import '/domain/blocs.dart';

class City {
  final String name;
  final String country;
  final double lat;
  final double lng;

  City({
    required this.name,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? json['city'] ?? '',
      country: json['country'] ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? json['latitude']?.toString() ?? '0.0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? json['longitude']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  String get displayName => '$name, $country';
}

class AnonymousReportFormScreen extends StatefulWidget {
  const AnonymousReportFormScreen({super.key});

  @override
  State<AnonymousReportFormScreen> createState() =>
      _AnonymousReportFormScreenState();
}

class _AnonymousReportFormScreenState extends State<AnonymousReportFormScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;
  City? _selectedCity;
  File? _attachedFile;
  List<String> _categories = [];
  List<City> _cities = [];
  List<City> _filteredCities = [];
  bool _isLoadingCities = true;

  late AnimationController _headerAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _formSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCities();
    context.read<ReportBloc>().add(LoadCategoriesEvent());
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
    });
  }

  Future<void> _loadCities() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/cities.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        _cities = jsonList.map((json) => City.fromJson(json)).toList();
        _cities.sort((a, b) => a.name.compareTo(b.name));
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCities = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cities: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _filterCities(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCities = [];
      });
      return;
    }

    setState(() {
      _filteredCities = _cities
          .where((city) =>
      city.name.toLowerCase().contains(query.toLowerCase()) ||
          city.country.toLowerCase().contains(query.toLowerCase()))
          .take(10)
          .toList();
    });
  }

  Future<void> _selectAttachment() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppLocalizations.of(context)!.addAttachment,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildAttachmentOption(
                icon: Icons.photo_camera,
                title: 'Take Photo',
                subtitle: 'Capture with camera',
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              _buildAttachmentOption(
                icon: Icons.photo_library,
                title: 'Choose from Gallery',
                subtitle: 'Select from photos',
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              _buildAttachmentOption(
                icon: Icons.attach_file,
                title: 'Choose File',
                subtitle: 'PDF, DOC, or other files',
                onTap: () => Navigator.pop(context, 'file'),
              ),
              if (_attachedFile != null)
                _buildAttachmentOption(
                  icon: Icons.delete_outline,
                  title: 'Remove Attachment',
                  subtitle: 'Clear current file',
                  onTap: () => Navigator.pop(context, 'remove'),
                  isDestructive: true,
                ),
              const SizedBox(height: 12),
              Text(
                _attachedFile != null
                    ? 'File attached: ${_attachedFile!.path.split('/').last}'
                    : AppLocalizations.of(context)!.addAttachmentOptional,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: _attachedFile != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              if (_attachedFile == null) ...[
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.attachmentTypes,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    if (action == null) return;

    switch (action) {
      case 'camera':
        final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (image != null) {
          setState(() => _attachedFile = File(image.path));
        }
        break;
      case 'gallery':
        final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (image != null) {
          setState(() => _attachedFile = File(image.path));
        }
        break;
      case 'file':
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        );
        if (result != null && result.files.first.path != null) {
          setState(() => _attachedFile = File(result.files.first.path!));
        }
        break;
      case 'remove':
        setState(() => _attachedFile = null);
        break;
    }
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary)
              .withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final isLoading = state is ReportLoading;

        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.submitAnonymously,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.privacy_tip_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.privacyNotice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedCity != null) {

      final languageBloc = context.read<LanguageBloc>();
      final currentLanguage = languageBloc.state.locale.languageCode;

      context.read<ReportBloc>().add(SubmitReportEvent(
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        latitude: _selectedCity!.lat,
        longitude: _selectedCity!.lng,
        language: currentLanguage,
        attachment: _attachedFile,
      ));
    } else {
      String errorMessage = '';
      if (_selectedCategory == null) {
        errorMessage = 'Please select a category';
      } else if (_selectedCity == null) {
        errorMessage = 'Please select a location';
      }

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatCategoryName(String category) {
    return category.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.helpPrivacy,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildHelpSection(
                AppLocalizations.of(context)!.completeAnonymity,
                AppLocalizations.of(context)!.anonymityDescription,
                Icons.security,
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                AppLocalizations.of(context)!.whatToInclude,
                AppLocalizations.of(context)!.includeDescription,
                Icons.checklist,
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                AppLocalizations.of(context)!.reportProcess,
                AppLocalizations.of(context)!.processDescription,
                Icons.assignment_outlined,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.gotIt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _formAnimationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReportBloc, ReportState>(
          listener: (context, state) {
            if (state is ReportSubmissionSuccess) {
              Navigator.of(context).pushReplacementNamed(
                '/submissionConfirmation',
                arguments: {
                  'referenceCode': state.referenceCode,
                  'passphrase': state.passphrase,
                  'reportId': state.reportId,
                },
              );
            } else if (state is ReportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (state is CategoriesLoaded) {
              setState(() {
                _categories = state.categories;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                Colors.white,
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          SlideTransition(
                            position: _formSlideAnimation,
                            child: Column(
                              children: [
                                _buildTitleField(),
                                const SizedBox(height: 20),
                                _buildCategoryField(),
                                const SizedBox(height: 20),
                                _buildLocationField(),
                                const SizedBox(height: 20),
                                _buildDescriptionField(),
                                const SizedBox(height: 20),
                                _buildAttachmentField(),
                                const SizedBox(height: 32),
                                _buildSubmitButton(),
                                const SizedBox(height: 24),
                                _buildPrivacyNotice(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelpDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFadeAnimation,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.security,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.anonymous,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.anonymousDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.reportTitle,
        hintText: AppLocalizations.of(context)!.briefTitle,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.title,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      maxLength: 200,
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'Please enter a title';
        }
        if (value!.length < 5) {
          return 'Title must be at least 5 characters';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.category,
        hintText: AppLocalizations.of(context)!.selectCategory,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      items: _categories.map((category) => DropdownMenuItem(
        value: category,
        child: Text(_formatCategoryName(category)),
      )).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildLocationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.location,
              hintText: _isLoadingCities ? 'Loading cities...' : AppLocalizations.of(context)!.searchCity,
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
              ),
              suffixIcon: _selectedCity != null
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _selectedCity = null;
                    _locationController.clear();
                    _filteredCities = [];
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: (value) {
              if (_selectedCity == null) {
                _filterCities(value);
              }
            },
            onTap: () {
              if (_selectedCity != null) {
                setState(() {
                  _selectedCity = null;
                  _locationController.clear();
                });
              }
            },
            readOnly: _selectedCity != null,
            validator: (value) => _selectedCity == null ? 'Please select a location' : null,
          ),
          if (_filteredCities.isNotEmpty && _selectedCity == null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCities.length,
                itemBuilder: (context, index) {
                  final city = _filteredCities[index];
                  return ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      city.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(city.country),
                    onTap: () {
                      setState(() {
                        _selectedCity = city;
                        _locationController.text = city.displayName;
                        _filteredCities = [];
                      });
                    },
                  );
                },
              ),
            ),
          if (_selectedCity != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selected: ${_selectedCity!.displayName}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      maxLength: 2000,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.descriptionOptional,
        hintText: AppLocalizations.of(context)!.detailedInfo,
        alignLabelWithHint: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(20),
      ),
      validator: (value) {
        if (value != null && value.length > 2000) {
          return 'Description cannot exceed 2000 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAttachmentField() {
    return GestureDetector(
      onTap: _selectAttachment,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _attachedFile != null
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_attachedFile != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _attachedFile != null ? Icons.check_circle : Icons.add_photo_alternate,
                size: 32,
                color: _attachedFile != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _attachedFile != null
                  ? 'File attached: ${_attachedFile!.path.split('/').last}'
                  : AppLocalizations.of(context)!.addAttachmentOptional,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: _attachedFile != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (_attachedFile == null) ...[
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.attachmentTypes,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}