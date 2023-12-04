// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/controlador/producto_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raised_buttons/raised_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  late XFile sampleImage = XFile('');
  final formKey = GlobalKey<FormState>();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  String productoId = generateId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cargar imagen"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage.path.isEmpty
            ? const Text("Seleccione una imagen")
            : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        tooltip: "Agregar imagen",
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      setState(() {
        sampleImage = XFile(tempImage.path);
      });
    }
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              File(sampleImage.path),
              height: 300,
              width: 600,
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: productoController,
              decoration: const InputDecoration(
                labelText: 'Alimento',
                prefixIcon: Icon(Icons.food_bank_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del alimento';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: cantidadController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                prefixIcon: Icon(Icons.unfold_more_double_sharp),
              ),
              // Filtro para permitir solo numeros
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la cantidad del alimento';
                }
                return null;
              },
              readOnly: false,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripcion',
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la descripcion del alimento';
                }
                return null;
              },
              readOnly: false,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: precioController,
              decoration: const InputDecoration(
                labelText: 'Precio del alimento',
                prefixIcon: Icon(Icons.monetization_on_outlined),
              ),
              // Filtro para permitir solo numeros
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el precio del alimento';
                }
                return null;
              },
              readOnly: false,
            ),
            const SizedBox(height: 16.0),
            RaisedButtons(
              GlobalKey<FormState>(),
              text: "Guardar",
              onPressed: () {
                validateAndSave();
                setState(() {});
              },
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // Subir la imagen a Firebase Storage
      uploadImage();
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadImage() async {
    try {
      String extension =
          sampleImage.path.split('.').last; // Obtener la extensión del archivo
      String fileName =
          "${productoId}_${DateTime.now().millisecondsSinceEpoch}.$extension";

      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref().child('imagesProductos').child(fileName);

      await reference.putFile(File(sampleImage.path));
      String downloadURL = await reference.getDownloadURL();
      print("Imagen subida con éxito. URL: $downloadURL");

      // Guardar la URL y el ID del producto en Firestore
      saveToFirestore(productoId, downloadURL);
      Navigator.pop(context);
    } catch (e) {
      print("Error al subir la imagen: $e");
    }
  }

  void saveToFirestore(String productId, String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        registerProducto(
            context,
            productoController.text,
            cantidadController.text,
            descripcionController.text,
            precioController.text,
            productoId,
            imageUrl);

        print("Datos guardados en Firestore");
      }
    } catch (e) {
      print("Error al guardar en Firestore: $e");
    }
  }
}
