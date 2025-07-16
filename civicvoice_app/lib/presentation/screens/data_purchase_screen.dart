import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/blocs.dart';

class DataPurchaseScreen extends StatefulWidget {
  const DataPurchaseScreen({super.key});

  @override
  State<DataPurchaseScreen> createState() => _DataPurchaseScreenState();
}

class _DataPurchaseScreenState extends State<DataPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _organizationController = TextEditingController();
  final _purposeController = TextEditingController();
  String? _selectedCategory;
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _organizationController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _estimateCost() {
    if (_formKey.currentState!.validate()) {
      final filters = <String, dynamic>{};

      if (_selectedCategory != null) {
        filters['category'] = _selectedCategory;
      }

      if (_dateRange != null) {
        filters['start_date'] = _dateRange!.start.toIso8601String();
        filters['end_date'] = _dateRange!.end.toIso8601String();
      }

      context.read<DataPurchaseBloc>().add(InitiatePurchaseEvent(filters: filters));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Data Package'),
      ),
      body: BlocListener<DataPurchaseBloc, DataPurchaseState>(
        listener: (context, state) {
          if (state is DataPurchaseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PurchaseInitiated) {
            _showPurchaseDialog(state);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Research Data',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Purchase anonymized governance report data for research purposes.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _organizationController,
                  decoration: const InputDecoration(
                    labelText: 'Organization',
                    hintText: 'Your research institution or organization',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter your organization';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Research Purpose',
                    hintText: 'Explain how you plan to use this data',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please describe your research purpose';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Data Filters (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category Filter',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Categories')),
                    DropdownMenuItem(value: 'corruption', child: Text('Corruption')),
                    DropdownMenuItem(value: 'infrastructure', child: Text('Infrastructure')),
                    DropdownMenuItem(value: 'healthcare', child: Text('Healthcare')),
                    DropdownMenuItem(value: 'education', child: Text('Education')),
                    DropdownMenuItem(value: 'environment', child: Text('Environment')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDateRange,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date Range Filter',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    child: Text(
                      _dateRange == null
                          ? 'All dates'
                          : '${_dateRange!.start.day}/${_dateRange!.start.month}/${_dateRange!.start.year} - ${_dateRange!.end.day}/${_dateRange!.end.month}/${_dateRange!.end.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pricing Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• \$0.50 per report'),
                      Text('• Minimum purchase: \$10.00'),
                      Text('• Download expires in 24 hours'),
                      Text('• Data is fully anonymized'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<DataPurchaseBloc, DataPurchaseState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state is DataPurchaseLoading ? null : _estimateCost,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: state is DataPurchaseLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Get Quote & Purchase'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  void _showPurchaseDialog(PurchaseInitiated state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports found: ${state.reportCount}'),
            Text('Total cost: \${state.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Note: This is a demo. Payment integration would be completed here.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment integration pending'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }
}