// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/campesino_controller.dart';
import 'package:ecosecha/vista/home_view_campesino.dart';
import 'package:ecosecha/vista/home_view_usuario.dart';
import 'package:ecosecha/vista/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  Future<void> signInUser(
      BuildContext context, String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        showPersonalizedAlert(
          context,
          'Por favor ingrese su email y contraseña',
          AlertMessageType.error,
        );
      } else {
        final FirebaseAuth auth = FirebaseAuth.instance;

        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        User? user = userCredential.user;
        String uid = user!.uid;
        String? camId = await CampesinoController().getCampesinoId();

        showPersonalizedAlert(
            context, "Inicio de sesion exitoso", AlertMessageType.success);

        if (uid == camId) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreenFarmer()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreenUser()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showPersonalizedAlert(
          context,
          'Usuario no encontrado',
          AlertMessageType.warning,
        );
      } else if (e.code == 'wrong-password') {
        showPersonalizedAlert(
          context,
          'Contraseña incorrecta',
          AlertMessageType.warning,
        );
      } else if (e.code == 'invalid-email') {
        showPersonalizedAlert(
          context,
          'El formato del correo electrónico\nno es válido.',
          AlertMessageType.error,
        );
      } else if (e.code == 'user-disabled') {
        showPersonalizedAlert(
          context,
          'Su cuenta está deshabilitada.',
          AlertMessageType.error,
        );
      } else if (e.code == 'network-request-failed') {
        showPersonalizedAlert(
          context,
          'Problema de red durante la autenticación.',
          AlertMessageType.error,
        );
      } else if (e.code == 'too-many-requests') {
        showPersonalizedAlert(
          context,
          'Demasiadas solicitudes desde el\nmismo dispositivo o IP.',
          AlertMessageType.error,
        );
      } else {
        showPersonalizedAlert(context, 'Error al iniciar sesión: ${e.message}',
            AlertMessageType.error);
        print(e.message);
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieveSession(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        // Obtener el ownerId desde Firestore
        String? ownerId = await CampesinoController().getCampesinoId();

        if (uid == ownerId) {
          // Si el UID del usuario es igual al ownerId, el usuario es un propietario
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreenFarmer()),
          );
        } else {
          // Si el UID del usuario no es igual al ownerId, el usuario es un cliente
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreenUser()),
          );
        }
      } else {
        // Si no hay usuario autenticado, redirigir a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } catch (e) {
      print('Error retrieving session: $e');
    }
  }
}
