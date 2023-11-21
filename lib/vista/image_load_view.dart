import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raised_buttons/raised_buttons.dart';

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  late XFile sampleImage = XFile('');
  final formkey = GlobalKey<FormState>();
  late String url;

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
        key: formkey,
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
            RaisedButtons(
              GlobalKey<
                  FormState>(), // Usa una nueva instancia de GlobalKey para RaisedButtons
              text: "Guardar",
              onPressed: () {
                validateAndSave();
              },
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      print("Formulario válido, realiza acciones de guardado aquí");
      return true;
    } else {
      return false;
    }
  }
}
