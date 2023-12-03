// ignore_for_file: library_private_types_in_public_api

// Importaciones necesarias para el archivo
import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/producto_controller.dart';
import 'package:ecosecha/logica/producto.dart';
import 'package:ecosecha/vista/editar_producto_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Clase StatefulWidget para la edición de producto
class ProductoEditController extends StatefulWidget {
  final Producto producto;
  // Constructor que toma un producto como parámetro
  const ProductoEditController({super.key, required this.producto});

  @override
  _ProductEditControllerState createState() => _ProductEditControllerState();
}

class _ProductEditControllerState extends State<ProductoEditController> {
  // Controladores para los campos de texto
  final TextEditingController nombreProductoController =
      TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  // Identificador del usuario actual
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Inicialización de controladores con valores actuales del electrodoméstico
    nombreProductoController.text = widget.producto.producto;
    cantidadController.text = widget.producto.cantidad;
    descripcionController.text = widget.producto.descripcion;
    precioController.text = widget.producto.precio;
  }

  // Función para actualizar los datos del producto
  void _update() async {
    try {
      // Obtención de valores de los controladores
      String name = nombreProductoController.text;
      String cantidad = cantidadController.text;
      String descripcion = descripcionController.text;
      String precio = precioController.text;

      // Verificación de campos vacíos antes de actualizar
      name.isEmpty
          ? name = widget.producto.producto
          : name = nombreProductoController.text;
      cantidad.isEmpty
          ? cantidad = widget.producto.cantidad.toString()
          : cantidad = cantidadController.text;
      descripcion.isEmpty
          ? descripcion = widget.producto.descripcion.toString()
          : descripcion = descripcionController.text;
      precio.isEmpty
          ? precio = widget.producto.precio.toString()
          : precio = precioController.text;

      // Creación de una instancia actualizada de Producto
      Producto producto = Producto(
          id: widget.producto.id,
          producto: name,
          cantidad: cantidad,
          descripcion: descripcion,
          precio: precio,
          user: uid,
          imageUrl: widget.producto.imageUrl);

      // Navegación de regreso y llamada a función de actualización
      Navigator.pop(context);
      actualizarProducto(producto);
      showPersonalizedAlert(context, 'Producto actualizado correctamente',
          AlertMessageType.success);
    } catch (e) {
      // Manejo de errores en caso de falla en la actualización
      showPersonalizedAlert(
          context, 'Error al actualizar el producto', AlertMessageType.error);
    }
  }

  @override
  void dispose() {
    // Liberación de recursos de los controladores al salir del widget
    nombreProductoController.dispose();
    cantidadController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Devuelve la vista para la edición de productos
    return ProductoEditView(
        productoController: nombreProductoController,
        cantidadController: cantidadController,
        descripcionController: descripcionController,
        precioController: precioController,
        updatePressed: _update);
  }
}
