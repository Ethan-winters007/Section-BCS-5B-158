import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/patient.dart';
import 'patient_form_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;
  PatientDetailScreen({required this.patient});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Detail'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PatientFormScreen(patient: patient),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            ),
          )
        ],
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
          child: ListView(children: [
            Center(
              child: Hero(
                tag: 'patient_${patient.id}',
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: patient.imagePath != null ? FileImage(File(patient.imagePath!)) : null,
                  child: patient.imagePath == null ? Icon(Icons.medical_information, size: 48, color: Colors.blue) : null,
                  backgroundColor: Colors.blue.shade50,
                ),
              ),
            ).animate().scale(delay: 200.ms),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Information', style: Theme.of(context).textTheme.titleLarge).animate().fadeIn(delay: 300.ms),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text('Name'),
                      subtitle: Text(patient.name, style: TextStyle(fontWeight: FontWeight.w500)),
                    ).animate().fadeIn(delay: 400.ms),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text('Age'),
                      subtitle: Text('${patient.age} years old'),
                    ).animate().fadeIn(delay: 500.ms),
                    ListTile(
                      leading: Icon(Icons.wc, color: Colors.blue),
                      title: Text('Gender'),
                      subtitle: Text(patient.gender),
                    ).animate().fadeIn(delay: 600.ms),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.blue),
                      title: Text('Phone'),
                      subtitle: Text(patient.phone),
                    ).animate().fadeIn(delay: 700.ms),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.1, end: 0),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medical Information', style: Theme.of(context).textTheme.titleLarge).animate().fadeIn(delay: 800.ms),
                    Divider(),
                    if (patient.bloodType != null)
                      ListTile(
                        leading: Icon(Icons.bloodtype, color: Colors.red),
                        title: Text('Blood Type'),
                        subtitle: Text(patient.bloodType!),
                      ).animate().fadeIn(delay: 900.ms),
                    if (patient.medicalHistory != null && patient.medicalHistory!.isNotEmpty)
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.blue),
                        title: Text('Medical History'),
                        subtitle: Text(patient.medicalHistory!),
                      ).animate().fadeIn(delay: 1000.ms),
                    if (patient.allergies != null && patient.allergies!.isNotEmpty)
                      ListTile(
                        leading: Icon(Icons.warning, color: Colors.orange),
                        title: Text('Allergies'),
                        subtitle: Text(patient.allergies!),
                      ).animate().fadeIn(delay: 1100.ms),
                    ListTile(
                      leading: Icon(Icons.note, color: Colors.blue),
                      title: Text('Notes'),
                      subtitle: Text(patient.notes.isNotEmpty ? patient.notes : 'No notes'),
                    ).animate().fadeIn(delay: 1200.ms),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.1, end: 0),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visit Information', style: Theme.of(context).textTheme.titleLarge).animate().fadeIn(delay: 1300.ms),
                    Divider(),
                    if (patient.createdAt != null)
                      ListTile(
                        leading: Icon(Icons.create, color: Colors.blue),
                        title: Text('Created At'),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(patient.createdAt!)),
                      ).animate().fadeIn(delay: 1400.ms),
                    if (patient.lastVisit != null)
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.blue),
                        title: Text('Last Visit'),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(patient.lastVisit!)),
                      ).animate().fadeIn(delay: 1500.ms),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.1, end: 0),
            if (patient.documentPath != null) ...[
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                  title: Text('Document'),
                  subtitle: Text(patient.documentPath!),
                  trailing: IconButton(
                    icon: Icon(Icons.open_in_new),
                    onPressed: () {
                      // TODO: Implement document opening
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Document opening not implemented yet')),
                      );
                    },
                  ),
                ).animate().fadeIn(delay: 1600.ms),
              ).animate().slideY(begin: 0.1, end: 0),
            ],
          ]),
        ),
      ),
    );
  }
}
