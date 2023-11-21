class Producto {
  final String id;
  final String producto;
  final String cantidad;
  final String descripcion;
  final String precio;
  final String user;

  Producto({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.descripcion,
    required this.precio,
    required this.user,
  });

  Producto.defaultConstructor()
      : id = 'ecosecha',
        producto = 'none',
        cantidad = '0',
        descripcion = 'none',
        precio = '0',
        user = 'none';

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      producto: json['producto'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      user: json['user']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'producto': producto,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'precio': precio,
        'user':user,
      };
}
