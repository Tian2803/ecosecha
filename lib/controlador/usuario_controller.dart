// ignore_for_file: use_build_context_synchronously
//FUNCIONA BIEN
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/logica/usuario.dart';
import 'package:ecosecha/vista/home_view_usuario.dart';
import 'package:ecosecha/vista/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserController {
  Future<String?> getUserName() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('usuario').doc(uid).get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      return userName as String;
    }
    return null;
  } catch (e) {
    throw Exception('No se pudo obtener el nombre del usuario.');
  }
}

void registerUser(
    BuildContext context,
    String name,
    String lastName,
    String address,
    String phone,
    String email,
    String password,
    String passwordConf,
    XFile profileImage) async {
  try {
    if (name.isEmpty ||
        lastName.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConf.isEmpty ||
        profileImage.path.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      bool isEmailValid = AuxController.validateEmail(email);
      bool isPasswordValid =
          AuxController.validatePasswords(password, passwordConf);

      if (isEmailValid && isPasswordValid) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          String idUser = userCredential.user!.uid;
          String extension = profileImage.path.split('.').last;
          String fileName =
              "${idUser}_${DateTime.now().millisecondsSinceEpoch}.$extension";

          firebase_storage.Reference reference = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child(fileName);

          await reference.putFile(File(profileImage.path));
          String downloadURL = await reference.getDownloadURL();
          print("Imagen subida con éxito. URL: $downloadURL");

          Usuario usuario = Usuario(
            id: idUser,
            name: name,
            lastName: lastName,
            address: address,
            email: email,
            phone: phone,
            profileImage: downloadURL,
          );

          await FirebaseFirestore.instance
              .collection('usuario')
              .doc(idUser)
              .set(usuario.toJson());

          showPersonalizedAlert(
              context, "Registro exitoso", AlertMessageType.success);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreenUser()),
          );
        } else {
          showPersonalizedAlert(context, 'Error al guardar datos del usuario',
              AlertMessageType.error);
        }
      } else {
        showPersonalizedAlert(
            context, "Las contraseñas no coinciden", AlertMessageType.error);
      }
    }
  } on FirebaseAuthException catch (e) {
    // Maneja errores específicos de FirebaseAuth
    if (e.code == 'email-already-in-use') {
      showPersonalizedAlert(
          context,
          'Correo electrónico ya registrado,\ninicia sesión en lugar de registrarse.',
          AlertMessageType.error);
    } else if (e.code == 'invalid-email') {
      showPersonalizedAlert(
          context,
          'El formato del correo electrónico\nno es válido.',
          AlertMessageType.error);
    } else if (e.code == 'operation-not-allowed') {
      showPersonalizedAlert(
          context,
          'La operación de registro no está\npermitida.',
          AlertMessageType.error);
    } else if (e.code == 'weak-password') {
      showPersonalizedAlert(
          context,
          'La contraseña es débil, debe tener\nal menos 10 caracteres.',
          AlertMessageType.error);
    } else {
      // Muestra una alerta si ocurre otro tipo de error en la autenticación
      showPersonalizedAlert(
          context, 'Error al registrar el usuario', AlertMessageType.error);
      print(e);
    }
  }
}

Future<String?> getUserId() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('usuario').doc(uid).get();

      if (userDoc.exists) {
        final customerId = userDoc.data()?['id'];
        return customerId as String;
      }
    } catch (e) {
      print('No existe el usuario en la colecccion.');
      print(e);
    }
    return null;
  }

  Future<void> updateAddress(String address, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'address': address,
    });
  }

  Future<void> updateEmail(String email, String uid) async {
    await FirebaseAuth.instance.currentUser!.updateEmail(email);

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'email': email,
    });
  }

  Future<void> updateLastName(String lastName, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'lastName': lastName,
    });
  }

  Future<void> updateName(String name, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'name': name,
    });
  }

  Future<void> updatePhone(String phone, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'phone': phone,
    });
  }

  Future<void> updateImageProfile(XFile image, String uid, String imageOld, BuildContext context) async {
    deleteImageProfile(imageOld);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Actualizando foto ..."),
            ],
          ),
        );
      },
    );
    String extension = image.path.split('.').last;
    String fileName =
        "${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension";

    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('userImages')
        .child(fileName);
    await reference.putFile(File(image.path));
    String downloadURL = await reference.getDownloadURL();
    print("Imagen subida con éxito. URL: $downloadURL");

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('usuario').doc(uid);
    await productRef.update({
      'profileImage': downloadURL,
    });
    
      Navigator.of(context).pop();
      Navigator.pop(context);
  }

  void deleteImageProfile(String imageUrl) {
    try {
      // Referencia al almacenamiento de Firebase
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instanceFor(bucket: 'userImages')
              .refFromURL(imageUrl);
      // Eliminar la imagen
      reference.delete();
      print("Imagen eliminada correctamente");
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}