// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/controlador/login_controller.dart';
import 'package:ecosecha/logica/campesino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void registerCompany(String name, String telefono, String email, String address,
    String password, String passwordConf, BuildContext context) async {
  try {
    if (name.isEmpty ||
        telefono.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        passwordConf.isEmpty) {
      showPersonalizedAlert(context, 'Por favor, complete todos los campos',
          AlertMessageType.warning);
    } else {
      bool isEmailValid = AuthController.validateEmail(email);
      bool isPasswordValid =
          AuthController.validatePasswords(password, passwordConf);
      if (isEmailValid && isPasswordValid) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String idUser = FirebaseAuth.instance.currentUser!.uid;

        Campesino campesino = Campesino(
            id: idUser,
            nameCampesino: name,
            emailCampesino: email,
            phoneCampesino: telefono,
            addressCampesino: address);

        await FirebaseFirestore.instance
            .collection('campesino')
            .doc(idUser)
            .set(campesino.toJson());

        showPersonalizedAlert(
          context,
          "Registro exitoso",
          AlertMessageType.notification,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      }
    }
  } catch (e) {
    showPersonalizedAlert(
        context, 'Error al registrar el campesino $e', AlertMessageType.error);
  }
}

Future<String?> getUserNameCampesino() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('campesino').doc(uid).get();
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

    final userDoc =
        await FirebaseFirestore.instance.collection('campesino').doc(uid).get();

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
          nameCampesino: doc['name'],
          emailCampesino: doc['email'],
          phoneCampesino: doc['phone'],
          addressCampesino: doc['address']));
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
