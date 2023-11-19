class Campesino {
  final String id;
  final String nameCampesino;
  final String emailCampesino;
  final String phoneCampesino;
  final String addressCampesino;

  Campesino({
    required this.id,
    required this.nameCampesino, 
    required this.emailCampesino, 
    required this.phoneCampesino,
    required this.addressCampesino
  });

  factory Campesino.fromJson(Map<String, dynamic> json) {
    return Campesino(
      id: json['id'],
      nameCampesino: json['name'],
      emailCampesino: json['email'],
      phoneCampesino: json['phone'],
      addressCampesino: json['address']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nameCampesino,
        'email': emailCampesino,
        'phone': phoneCampesino,
        'address':addressCampesino,
      };
}
