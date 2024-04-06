class Campesino {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String profileImage;

  Campesino({
    required this.id,
    required this.name,
    required this.lastName, 
    required this.email, 
    required this.phone,
    required this.address,
    required this.profileImage
  });

  factory Campesino.fromJson(Map<String, dynamic> json) {
    return Campesino(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profileImage: json['profileImage']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address':address,
        'profileImage': profileImage
      };
}
