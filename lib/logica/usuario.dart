// company.dart

class Usuario {
  final String id;
  final String name;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String profileImage;

  Usuario({
    required this.id,
    required this.name,
    required this.lastName,
    required this.address, 
    required this.email, 
    required this.phone,
    required this.profileImage
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastName': lastName,
        'address': address,
        'email': email,
        'phone': phone,
        'profileImage': profileImage
      };

  String getUserName() {
    return name;
  }
}
