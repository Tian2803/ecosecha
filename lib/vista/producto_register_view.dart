// ignore_for_file: modelo_key_in_widget_constructors

import 'dart:io';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/controlador/producto_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raised_buttons/raised_buttons.dart';

class FoodRegisterView extends StatefulWidget {
  const FoodRegisterView({super.key});

  @override
  State<FoodRegisterView> createState() => _FoodRegisterViewState();
}

class _FoodRegisterViewState extends State<FoodRegisterView> {
  final TextEditingController productoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  String productoId = generateId();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Register Food'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 5),
                TextFormField(
                  controller: productoController,
                  decoration: const InputDecoration(
                    labelText: 'Alimento',
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.unfold_more_double_sharp),
                  ),
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio del alimento';
                    }
                    return null;
                  },
                  readOnly: false,
                ),
                IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    iconSize: 40,
                    color: Colors.amber,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const PhotoUpload();
                      }));
                    }),
                const SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () {
                    registerFood(
                        context,
                        productoController.text,
                        cantidadController.text,
                        descripcionController.text,
                        precioController.text,
                        productoId);
                    setState(() {
                      productoController.clear();
                      cantidadController.clear();
                      descripcionController.clear();
                      precioController.clear();
                    });
                  },
                  child: const Text('Registrar'),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({super.key});

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  late File sampleImage = File('');
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cargar imagen"),
        centerTitle: true,
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: sampleImage == null
            ? const Text("Saleccione una imagen")
            : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Agregar imagen",
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage as File;
    });
  }

  Widget enableUpload() {
    return SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Image.file(
                  sampleImage,
                  height: 300,
                  width: 600,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                RaisedButtons(formkey, text: "Guardar", onPressed: () {
                  validateAndSave();
                }, fontSize: 18)
              ],
            )));
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      print("Formulario válido, realiza acciones de guardado aquí");
      return true;
    } else {
      return false;
    }
  }

  /*void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post images");
      var timekey = DateTime.now();

    }
  }*/
}
