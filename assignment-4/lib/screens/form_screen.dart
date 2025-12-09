import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/submission.dart';

class FormScreen extends StatefulWidget {
  final Submission? existing;

  const FormScreen({super.key, this.existing});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = SupabaseService();

  late TextEditingController fullName;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;

  String gender = "Male";

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController(text: widget.existing?.fullName ?? "");
    email = TextEditingController(text: widget.existing?.email ?? "");
    phone = TextEditingController(text: widget.existing?.phone ?? "");
    address = TextEditingController(text: widget.existing?.address ?? "");
    gender = widget.existing?.gender ?? "Male";
  }

  void saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final entry = Submission(
      id: widget.existing?.id ?? 0,
      fullName: fullName.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      address: address.text.trim(),
      gender: gender,
    );

    if (widget.existing == null) {
      await supabase.insert(entry);
    } else {
      await supabase.update(entry.id, entry);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.existing == null ? "Add Submission" : "Edit Submission"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullName,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.contains("@") ? null : "Enter valid email",
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (v) => v!.length < 10 ? "Enter valid number" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (v) => v!.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 20),

              const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v.toString()),
                  ),
                  const Text("Male"),
                  Radio(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v.toString()),
                  ),
                  const Text("Female"),
                  Radio(
                    value: "Other",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v.toString()),
                  ),
                  const Text("Other"),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveRecord,
                child: Text(widget.existing == null ? "Submit" : "Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
