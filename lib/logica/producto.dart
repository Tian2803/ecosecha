class Producto {
  final String id;
  final String producto;
  final String cantidad;
  final String descripcion;
  final String precio;
  final String user;
  final String imageUrl; // Add imageUrl attribute

  Producto({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.descripcion,
    required this.precio,
    required this.user,
    required this.imageUrl, // Include imageUrl in the constructor
  });

  Producto.defaultConstructor()
      : id = 'ecosecha',
        producto = 'none',
        cantidad = '0',
        descripcion = 'none',
        precio = '0',
        user = 'none',
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/ecosecha-b539c.appspot.com/o/loading.gif?alt=media&token=46c14757-6666-4ddf-a886-b95e183ac967'; // Set a default value for imageUrl

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      producto: json['producto'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      user: json['user'],
      imageUrl: json['imageUrl'], // Retrieve imageUrl from the JSON
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'producto': producto,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'precio': precio,
        'user': user,
        'imageUrl': imageUrl, // Include imageUrl in the JSON
      };
}
