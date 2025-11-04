import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/user_provider.dart';
import '../models/case_model.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _gender = 'Male';
  String _location = '';
  LatLng? _selectedLocation;
  final List<File> _images = [];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Case')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (value) => setState(() => _gender = value!),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickLocation,
                child: Text(_location.isEmpty ? 'Select Location' : _location),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Upload Images'),
              ),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(_images[index], width: 80, height: 80, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitCase,
                      child: const Text('Submit Report'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images != null) {
      setState(() => _images.addAll(images.map((i) => File(i.path))));
    }
  }

  Future<void> _pickLocation() async {
    // TODO: Implement Google Maps location picker
    // For now, mock location
    setState(() {
      _location = 'Selected Location';
      _selectedLocation = const LatLng(0, 0);
    });
  }

  Future<void> _submitCase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = context.read<UserProvider>().user!;
      final caseItem = Case(
        id: 'case_${DateTime.now().millisecondsSinceEpoch}',
        userId: user.id,
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _gender,
        description: _descriptionController.text,
        location: _location,
        imageUrls: _images.map((i) => i.path).toList(),
        status: 'scanning',
        submittedAt: DateTime.now(),
      );

      await FirebaseService().addCase(caseItem);

      // Trigger AI matching
      final match = await AIService().findMatch(caseItem.id, caseItem.imageUrls);
      if (match != null) {
        await FirebaseService().addMatch(match);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}