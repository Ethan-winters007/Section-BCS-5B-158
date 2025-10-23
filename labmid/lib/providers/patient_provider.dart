import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../database/database_helper.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];
  bool _loading = true;

  List<Patient> get patients => _patients;
  bool get loading => _loading;

  Future<void> loadPatients() async {
    try {
      _loading = true;
      notifyListeners();
      _patients = await DatabaseHelper.instance.getAll();
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      await DatabaseHelper.instance.insert(patient);
      await loadPatients();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePatient(Patient patient) async {
    try {
      await DatabaseHelper.instance.update(patient);
      await loadPatients();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePatient(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      await loadPatients();
    } catch (e) {
      throw e;
    }
  }
}
