import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/patient.dart';
import '../providers/patient_provider.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient? patient;
  PatientFormScreen({this.patient});
  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _phone = TextEditingController();
  final _notes = TextEditingController();
  final _medicalHistory = TextEditingController();
  final _allergies = TextEditingController();
  String _gender = 'Male';
  String _bloodType = 'A+';
  String? _imagePath;
  String? _documentPath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _name.text = widget.patient!.name;
      _age.text = widget.patient!.age.toString();
      _phone.text = widget.patient!.phone;
      _notes.text = widget.patient!.notes;
      _gender = widget.patient!.gender;
      _imagePath = widget.patient!.imagePath;
      _documentPath = widget.patient!.documentPath;
      _medicalHistory.text = widget.patient!.medicalHistory ?? '';
      _allergies.text = widget.patient!.allergies ?? '';
      _bloodType = widget.patient!.bloodType ?? 'A+';
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _imagePath = file.path);
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) setState(() => _documentPath = result.files.single.path);
  }

  void save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final p = Patient(
        id: widget.patient?.id,
        name: _name.text.trim(),
        age: int.tryParse(_age.text.trim()) ?? 0,
        gender: _gender,
        phone: _phone.text.trim(),
        notes: _notes.text.trim(),
        imagePath: _imagePath,
        documentPath: _documentPath,
        createdAt: widget.patient?.createdAt ?? DateTime.now(),
        lastVisit: DateTime.now(),
        medicalHistory: _medicalHistory.text.trim().isEmpty ? null : _medicalHistory.text.trim(),
        allergies: _allergies.text.trim().isEmpty ? null : _allergies.text.trim(),
        bloodType: _bloodType,
      );
      if (widget.patient == null) {
        await context.read<PatientProvider>().addPatient(p);
      } else {
        await context.read<PatientProvider>().updatePatient(p);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.patient == null ? 'Patient added successfully!' : 'Patient updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save patient: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.patient != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Patient' : 'Add Patient'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                AnimatedScale(
                  scale: _imagePath != null ? 1.0 : 0.9,
                  duration: Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                      child: _imagePath == null ? Icon(Icons.camera_alt, size: 32, color: Colors.blue) : null,
                      backgroundColor: Colors.blue.shade50,
                    ),
                  ),
                ).animate().scale(delay: 200.ms),
                SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ).animate().fadeIn(delay: 300.ms),
                SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _age,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v.trim()) == null) return 'Enter a valid number';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                  ),
                ]).animate().fadeIn(delay: 400.ms),
                SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    // Basic phone validation
                    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(v.trim())) return 'Enter a valid phone number';
                    return null;
                  },
                ).animate().fadeIn(delay: 500.ms),
                SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: 4,
                ).animate().fadeIn(delay: 600.ms),
                SizedBox(height: 12),
                TextFormField(
                  controller: _medicalHistory,
                  decoration: InputDecoration(labelText: 'Medical History'),
                  maxLines: 3,
                ).animate().fadeIn(delay: 700.ms),
                SizedBox(height: 12),
                TextFormField(
                  controller: _allergies,
                  decoration: InputDecoration(labelText: 'Allergies'),
                  maxLines: 2,
                ).animate().fadeIn(delay: 800.ms),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _bloodType,
                  items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((bt) => DropdownMenuItem(value: bt, child: Text(bt))).toList(),
                  onChanged: (v) => setState(() => _bloodType = v ?? 'A+'),
                  decoration: InputDecoration(labelText: 'Blood Type'),
                ).animate().fadeIn(delay: 900.ms),
                SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: pickDocument,
                      icon: Icon(Icons.attach_file),
                      label: Text(_documentPath == null ? 'Upload Document' : 'Change Document'),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  if (_documentPath != null) SizedBox(width: 8),
                  if (_documentPath != null)
                    IconButton(onPressed: () => setState(() => _documentPath = null), icon: Icon(Icons.delete, color: Colors.red)),
                ]).animate().fadeIn(delay: 1000.ms),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : () => save(context),
                    child: _saving
                        ? CircularProgressIndicator(color: Colors.white)
                        : Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text(editing ? 'Update' : 'Add')),
                  ),
                ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.1, end: 0),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
