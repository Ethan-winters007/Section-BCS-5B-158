class Patient {
  int? id;
  String name;
  int age;
  String gender;
  String phone;
  String notes;
  String? imagePath;
  String? documentPath;
  DateTime? createdAt;
  DateTime? lastVisit;
  String? medicalHistory;
  String? allergies;
  String? bloodType;

  Patient({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.notes,
    this.imagePath,
    this.documentPath,
    this.createdAt,
    this.lastVisit,
    this.medicalHistory,
    this.allergies,
    this.bloodType,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      phone: map['phone'],
      notes: map['notes'],
      imagePath: map['imagePath'],
      documentPath: map['documentPath'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      lastVisit: map['lastVisit'] != null ? DateTime.parse(map['lastVisit']) : null,
      medicalHistory: map['medicalHistory'],
      allergies: map['allergies'],
      bloodType: map['bloodType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'notes': notes,
      'imagePath': imagePath,
      'documentPath': documentPath,
      'createdAt': createdAt?.toIso8601String(),
      'lastVisit': lastVisit?.toIso8601String(),
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'bloodType': bloodType,
    };
  }
}
