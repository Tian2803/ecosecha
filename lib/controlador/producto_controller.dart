//YA FUNCIONA BIEN
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/logica/producto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Detalles vista campesino => en uso
class ProductController {
  Future<List<Product>> getProductDetails(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore
          .collection('productos')
          .where('user', isEqualTo: userId)
          .get();

      // Inicializa una lista para almacenar los productos
      List<Product> productos = [];
      // Recorre los documentos y crea instancias de la clase Producto
      for (var doc in snapshot.docs) {
        productos.add(Product(
          id: doc['id'],
          product: doc['product'],
          quantity: doc['quantity'],
          description: doc['description'],
          price: doc['price'],
          category: doc['category'],
          user: doc['user'],
          productImage: doc['productImage'] ??
              'none', // Include productImage with a default value
        ));
      }
      // Devuelve la lista de productos
      return productos;
    } catch (e) {
      // Maneja errores de forma adecuada
      throw Exception('No se pudo obtener la información de los productos.');
    }
  }

  Future<void> updateProduct(
      Product product, XFile image, BuildContext context) async {
    try {
      String downloadURL = product.productImage;
      deleteImageProduct(downloadURL);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Actualizando producto..."),
              ],
            ),
          );
        },
      );

      if (image.path.isNotEmpty) {
        print("Hola ${image.path}");

        String extension = image.path.split('.').last;
        String fileName =
            "${product.id}_${DateTime.now().millisecondsSinceEpoch}.$extension";

        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child(fileName);

        await reference.putFile(File(image.path));
        downloadURL = await reference.getDownloadURL();
        print("Imagen subida con éxito. URL: $downloadURL");
      }

      // Obtén una referencia al documento del producto en Firestore
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('productos')
          .doc(product.id);

      // Actualiza los campos del producto en Firestore
      await productRef.update({
        'product': product.product,
        'quantity': product.quantity,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'productImage': downloadURL,
      });
      Navigator.of(context).pop();
      print("Producto actualizado con éxito");
      showPersonalizedAlert(
          context, "Actualizacion exitosa", AlertMessageType.success);
    } catch (error) {
      Navigator.of(context).pop();
      print("Error al actualizar el producto: $error");
      showPersonalizedAlert(
          context, "Actualizacion fallida", AlertMessageType.error);
    }
  }

//En uso
  void registerProduct(
    BuildContext context,
    String producto,
    String quantity,
    String description,
    String price,
    String category,
    XFile productImage, // Include productImage parameter
  ) async {
    try {
      if (producto.isEmpty ||
          quantity.isEmpty ||
          description.isEmpty ||
          price.isEmpty ||
          category.isEmpty ||
          productImage.path.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, llene todos los campos',
            AlertMessageType.warning);
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Guardando producto..."),
              ],
            ),
          );
        },
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;

      String productId = AuxController().generateId();

      String extension =
          productImage.path.split('.').last; // Obtener la extensión del archivo
      String fileName =
          "${productId}_${DateTime.now().millisecondsSinceEpoch}.$extension";

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('productImages')
          .child(fileName);

      await reference.putFile(File(productImage.path));
      String downloadURL = await reference.getDownloadURL();
      print("Imagen subida con éxito. URL: $downloadURL");

      Product product = Product(
        id: productId,
        product: producto,
        quantity: int.parse(quantity),
        description: description,
        price: double.parse(price),
        category: category,
        user: uid,
        productImage: downloadURL, // Pass productImage to the constructor
      );

      await FirebaseFirestore.instance
          .collection('productos')
          .doc(productId)
          .set(product.toJson());

      // Cerrar el indicador de carga
      Navigator.of(context).pop();

      showPersonalizedAlert(
          context, "Registro exitoso", AlertMessageType.success);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showPersonalizedAlert(
          context, 'Error al registrar la Food', AlertMessageType.error);
    }
  }

//En uso
  Future<Product> getProduct(String productoId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .where('id', isEqualTo: productoId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Map the data to a Food object
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Product producto = Product(
          id: data['id'],
          product: data['product'],
          quantity: data['quantity'],
          description: data['description'],
          price: data['price'],
          category: data['category'],
          user: data['user'],
          productImage:
              data['productImage'], // Include productImage in the instantiation
        );

        return producto;
      } else {
        // No se encontró la comida con el ID proporcionado
        throw Exception('No se encontró la comida con el ID proporcionado');
      }
    } catch (e) {
      throw Exception('No se pudo obtener el producto.');
    }
  }

//En uso
  Future<List<Product>> getProductsDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore.collection('productos').get();

      // Inicializa una lista para almacenar los productos
      List<Product> productos = [];
      // Recorre los documentos y crea instancias de la clase Producto
      for (var doc in snapshot.docs) {
        productos.add(Product(
          id: doc['id'],
          product: doc['product'],
          quantity: doc['quantity'],
          description: doc['description'],
          price: doc['price'],
          category: doc['category'],
          user: doc['user'],
          productImage: doc['productImage'] ??
              'none', // Include productImage with a default value
        ));
      }

      // Devuelve la lista de productos
      return productos;
    } catch (e) {
      // Maneja errores de forma adecuada
      throw Exception('No se pudo obtener la información de los productos.');
    }
  }

  void deleteProduct(Product product) {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('productos').doc(product.id);

    productRef.delete().then((doc) {
      print("Producto eliminado correctamente");
      deleteImageProduct(product.productImage);
      print(product.productImage);
    }).catchError((error) {
      print('Error al eliminar el producto: $error');
    });
  }

  void deleteImageProduct(String imageUrl) {
    try {
      // Referencia al almacenamiento de Firebase
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instanceFor(bucket: 'productImages')
              .refFromURL(imageUrl);
      // Eliminar la imagen
      reference.delete();
      print("Imagen eliminada correctamente");
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }

  Future<String> getNameProduct(String idProducto) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('productos')
          .doc(idProducto)
          .get();

      if (userDoc.exists) {
        final producto = userDoc.data()?['product'];
        return producto as String;
      } else {
        return "No existe";
      }
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del producto.');
    }
  }
}
