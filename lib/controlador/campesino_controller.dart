// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/logica/campesino.dart';
import 'package:ecosecha/vista/home_view_campesino.dart';
import 'package:ecosecha/vista/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CampesinoController {
  void registerFarmer(
      String name,
      String lastName,
      String phone,
      String email,
      String address,
      String password,
      String passwordConf,
      XFile profileImage,
      BuildContext context) async {
    try {
      if (name.isEmpty ||
          phone.isEmpty ||
          email.isEmpty ||
          address.isEmpty ||
          password.isEmpty ||
          passwordConf.isEmpty ||
          lastName.isEmpty ||
          profileImage.path.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, complete todos los campos',
            AlertMessageType.warning);
      } else {
        bool isEmailValid = AuxController.validateEmail(email);
        bool isPasswordValid =
            AuxController.validatePasswords(password, passwordConf);
        if (isEmailValid && isPasswordValid) {
          UserCredential farmerCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (farmerCredential.user != null) {
            String idUser = FirebaseAuth.instance.currentUser!.uid;
            String extension = profileImage.path.split('.').last;
            String fileName =
                "${idUser}_${DateTime.now().millisecondsSinceEpoch}.$extension";

            firebase_storage.Reference reference = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child('farmerImages')
                .child(fileName);

            await reference.putFile(File(profileImage.path));
            String downloadURL = await reference.getDownloadURL();
            print("Imagen subida con éxito. URL: $downloadURL");

            Campesino campesino = Campesino(
                id: idUser,
                name: name,
                lastName: lastName,
                email: email,
                phone: phone,
                address: address,
                profileImage: downloadURL);

            await FirebaseFirestore.instance
                .collection('campesino')
                .doc(idUser)
                .set(campesino.toJson());

            showPersonalizedAlert(
              context,
              "Registro exitoso",
              AlertMessageType.success,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreenFarmer()),
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

  Future<String?> getUserNameCampesino() async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('campesino')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final name = userDoc.data()?['name'] as String?;
        print(name);
        return name;
      }
      return null;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre de la compañía.');
    }
  }

  Future<String?> getCampesinoId() async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;

      final uid = user.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('campesino')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final companyId = userDoc.data()?['id'];
        return companyId as String;
      }
      return null;
    } catch (e) {
      throw Exception('No se pudo obtener el identificador de la empresa.');
    }
  }

  Future<List<Campesino>> getCompanyDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore.collection('campesino').get();

      // Inicializa una lista para almacenar los electrodomésticos
      List<Campesino> company = [];
      // Recorre los documentos y crea instancias de la clase Appliance
      for (var doc in snapshot.docs) {
        company.add(Campesino(
            id: doc.id,
            name: doc['name'],
            lastName: doc['lastName'],
            email: doc['email'],
            phone: doc['phone'],
            address: doc['address'],
            profileImage: doc['profileImage']));
      }
      // Devuelve la lista de electrodomésticos
      return company;
    } catch (e) {
      // Maneja errores de forma adecuada
      print('Error, no se logro obtener la información de los: $e');
      throw Exception('No se pudo obtener la información de los expertos.');
    }
  }

  Future<String> getName(String idCampesino) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('campesino')
          .doc(idCampesino)
          .get();

      final userName = userDoc.data()?['name'];
      print(userName);
      return userName as String;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }

  Future<void> updateAddress(String address, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
    await productRef.update({
      'address': address,
    });
  }

  Future<void> updateEmail(String email, String uid) async {
    await FirebaseAuth.instance.currentUser!.updateEmail(email);

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
    await productRef.update({
      'email': email,
    });
  }

  Future<void> updateLastName(String lastName, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
    await productRef.update({
      'lastName': lastName,
    });
  }

  Future<void> updateName(String name, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
    await productRef.update({
      'name': name,
    });
  }

  Future<void> updatePhone(String phone, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
    await productRef.update({
      'phone': phone,
    });
  }

  Future<void> updateImageProfile(
      XFile image, String uid, String imageOld, BuildContext context) async {

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
        .child('farmerImages')
        .child(fileName);
    await reference.putFile(File(image.path));
    String downloadURL = await reference.getDownloadURL();
    print("Imagen subida con éxito. URL: $downloadURL");

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('campesino').doc(uid);
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
          firebase_storage.FirebaseStorage.instanceFor(bucket: 'farmerImages')
              .refFromURL(imageUrl);
      // Eliminar la imagen
      reference.delete();
      print("Imagen eliminada correctamente");
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}

