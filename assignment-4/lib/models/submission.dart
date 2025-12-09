
class Submission {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String gender;

  Submission({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
    };
  }
}
