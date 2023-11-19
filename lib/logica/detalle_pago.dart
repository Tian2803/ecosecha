class DetallePago {
  final String idDetallePago;
  final String productoId;
  final String campesinoId;
  final String userId;
  final String cantidad;
  final String pago;
  final String fecha;

  DetallePago({
    required this.idDetallePago,
    required this.productoId,
    required this.campesinoId,
    required this.userId,
    required this.cantidad,
    required this.pago,
    required this.fecha
  });

  factory DetallePago.fromJson(Map<String, dynamic> json) {
    return DetallePago(
      idDetallePago: json['idDetallePago'],
      productoId: json['productoId'],
      campesinoId: json['campesinoId'],
      userId: json['userId'],
      pago: json['pago'],
      cantidad: json['cantidad'],
      fecha: json['fecha']
    );
  }

  Map<String, dynamic> toJson() => {
        'idDetallePago': idDetallePago,
        'productoId': productoId,
        'campesinoId': campesinoId,
        'userId': userId,
        'cantidad': cantidad,
        'pago': pago,
        'fecha': fecha
      };
}
