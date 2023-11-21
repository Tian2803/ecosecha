

//YA FUNCIONA BIEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/logica/producto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Detalles vista campesino
Future<List<Producto>> getProductoDetails(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('producto')
        .where('user', isEqualTo: userId)
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Producto> producto = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    for (var doc in snapshot.docs) {
      producto.add(Producto(
        id: doc['id'],
        producto: doc['producto'],
        cantidad: doc['cantidad'],
        descripcion: doc['descripcion'],
        precio: doc['precio'],
        user: doc['user'],
      ));
    }

    // Devuelve la lista de alimentos
    return producto;
  } catch (e) {
    // Maneja errores de forma adecuada
    throw Exception(
        'No se pudo obtener la información de las comidas.');
  }
}

void updateFood(Producto producto) {
  // Obtén una referencia al documento del producto en Firestore
  DocumentReference applianceRef =
      FirebaseFirestore.instance.collection('producto').doc(producto.id);

  // Actualiza los campos del producto en Firestore
  applianceRef.update({
    'producto': producto.producto,
    'cantidad': producto.cantidad,
    'descripcion': producto.descripcion,
    'precio': producto.precio
  }).then((_) {
  }).catchError((error) {
  });
}

void deleteProducto(Producto producto) {
  DocumentReference productoRef =
      FirebaseFirestore.instance.collection('producto').doc(producto.id);

  productoRef.delete().then((doc) {
  }).catchError((error) {
  });
}

void registerProducto(
    BuildContext context,
    String producto,
    String cantidad,
    String descripcion,
    String precio,
    String productoId) async {
  try {
    if (producto.isEmpty ||
        cantidad.isEmpty ||
        descripcion.isEmpty ||
        precio.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, llene todos los campos',
          AlertMessageType.warning);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    Producto product = Producto(
      id: productoId,
      producto: producto,
      cantidad: cantidad,
      descripcion: descripcion,
      precio: precio,
      user: uid,
    );

    await FirebaseFirestore.instance
        .collection('producto')
        .doc(productoId)
        .set(product.toJson());
  } catch (e) {
    // ignore: use_build_context_synchronously
    showPersonalizedAlert(context, 'Error al registrar la Food',
        AlertMessageType.error);
  }
}

Future<String> getFoodId(String nameFood, String userId) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('electrodomestico')
        .where('name', isEqualTo: nameFood)
        .where('user', isEqualTo: userId)
        .get();

    final foodId = querySnapshot.docs.first.id;
    return foodId;
    // No se encontró el electrodoméstico con el nombre proporcionado
  } catch (e) {
    throw Exception(
        'No se pudo obtener el identificador de la comida.');
  }
}

Future<Producto> getProducto(String productoId) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('producto')
        .where('id', isEqualTo: productoId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Map the data to a Food object
      Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      Producto producto = Producto(
        id: data['id'],
        producto: data['producto'],
        cantidad: data['cantidad'],
        descripcion: data['descripcion'],
        precio: data['precio'],
        user: data['user'],
      );

      return producto;
    } else {
      // No se encontró la comida con el ID proporcionado
      throw Exception('No se encontró la comida con el ID proporcionado');
    }
  } catch (e) {
    throw Exception('No se pudo obtener la comida.');
  }
}

Future<List<Producto>> getProductosDetails() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Realiza la consulta a Firebase Firestore
    QuerySnapshot snapshot = await firestore
        .collection('producto')
        .get();

    // Inicializa una lista para almacenar los electrodomésticos
    List<Producto> producto = [];
    // Recorre los documentos y crea instancias de la clase Appliance
    for (var doc in snapshot.docs) {
      producto.add(Producto(
        id: doc['id'],
        producto: doc['producto'],
        cantidad: doc['cantidad'],
        descripcion: doc['descripcion'],
        precio: doc['precio'],
        user: doc['user'],
      ));
    }

    // Devuelve la lista de alimentos
    return producto;
  } catch (e) {
    // Maneja errores de forma adecuada
    throw Exception(
        'No se pudo obtener la información de las comidas.');
  }
}