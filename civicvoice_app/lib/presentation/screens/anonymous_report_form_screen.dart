import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '/domain/blocs.dart';

class AnonymousReportFormScreen extends StatefulWidget {
  const AnonymousReportFormScreen({super.key});

  @override
  State<AnonymousReportFormScreen> createState() =>
      _AnonymousReportFormScreenState();
}

class _AnonymousReportFormScreenState extends State<AnonymousReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  double? _latitude;
  double? _longitude;
  String _locationText = 'Tap to select location';
  File? _attachedFile;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation() async {
    // TODO: Integrate with map service
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text(
              'Select Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Map integration pending',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'For now, using default location',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'latitude': -1.9396, // Kigali coordinates
                        'longitude': 30.0444,
                        'address': 'Kigali, Rwanda',
                      });
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _latitude = result['latitude'];
        _longitude = result['longitude'];
        _locationText = result['address'];
      });
    }
  }

  Future<void> _selectAttachment() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Choose File'),
              onTap: () => Navigator.pop(context, 'file'),
            ),
            if (_attachedFile != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Attachment'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );

    if (action == null) return;

    switch (action) {
      case 'camera':
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() => _attachedFile = File(image.path));
        }
        break;
      case 'gallery':
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  void _submitReport() {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _latitude != null &&
        _longitude != null) {

      final languageBloc = context.read<LanguageBloc>();
      final currentLanguage = languageBloc.state.locale.languageCode;

      context.read<ReportBloc>().add(SubmitReportEvent(
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        latitude: _latitude!,
        longitude: _longitude!,
        language: currentLanguage,
        attachment: _attachedFile,
      ));
    } else {
      String errorMessage = '';
      if (_selectedCategory == null) {
        errorMessage = 'Please select a category';
      } else if (_latitude == null || _longitude == null) {
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
        appBar: AppBar(
          title: const Text('Submit Report'),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelpDialog(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildLocationField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildAttachmentField(),
                const SizedBox(height: 32),
                BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state is ReportLoading ? null : _submitReport,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: state is ReportLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Submit Anonymously'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildPrivacyNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock_outline,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Anonymous Report',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your identity will remain confidential',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Report Title *',
        hintText: 'Brief title of the issue',
        prefixIcon: Icon(Icons.title),
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Select category'),
      decoration: const InputDecoration(
        labelText: 'Category *',
        prefixIcon: Icon(Icons.category),
      ),
      items: _categories.map((category) => DropdownMenuItem(
        value: category,
        child: Text(_formatCategoryName(category)),
      )).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  String _formatCategoryName(String category) {
    return category.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: _selectLocation,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Location *',
            hintText: _locationText,
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: _latitude != null
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _latitude = null;
                _longitude = null;
                _locationText = 'Tap to select location';
              }),
            )
                : const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          validator: (value) => _latitude == null ? 'Please select a location' : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      maxLength: 2000,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Provide more details about the issue...',
        alignLabelWithHint: true,
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
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              _attachedFile != null ? Icons.attach_file : Icons.add_photo_alternate,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              _attachedFile != null
                  ? 'File attached: ${_attachedFile!.path.split('/').last}'
                  : 'Add attachment (optional)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _attachedFile != null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (_attachedFile == null) ...[
              const SizedBox(height: 4),
              Text(
                'Supports: Images, PDF, Documents',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.privacy_tip_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your report is completely anonymous. We do not collect any personal information.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Privacy'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Complete Anonymity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Your personal information is never collected or stored. Reports cannot be traced back to you.'),
              SizedBox(height: 16),
              Text(
                'What to Include',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Clear, factual description\n• Specific location\n• Supporting documents if available\n• Date and time when possible'),
              SizedBox(height: 16),
              Text(
                'Report Process',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Reports are reviewed by verified moderators and may be published on the public dashboard after verification.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}