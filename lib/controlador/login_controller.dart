
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/campesino_controller.dart';
import 'package:ecosecha/vista/home_view_campesino.dart';
import 'package:ecosecha/vista/login_view.dart';
import 'package:ecosecha/vista/home_view_usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends StatefulWidget {
  const LoginController();

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final bool _isEmailValid = true;
  final bool _isPasswordValid = true;

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Extrayendo la información de la compañía autenticada desde la base de datos
      User? user = userCredential.user;
      String userId = user!.uid;
      String? expId = await getCampesinoId();
      // Navegando a la vista de electrodomesticos
      if (userId == expId) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeViewCompany()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeViewUser()));
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
      }
    }
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validando que el email y la contraseña no estén vacíos
    if (email.isEmpty || password.isEmpty) {
      showPersonalizedAlert(context, 'Por favor ingrese su email y contraseña',
          AlertMessageType.error);
      return;
    }

    signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return LoginView(
      emailController: _emailController,
      passwordController: _passwordController,
      isEmailValid: _isEmailValid,
      isPasswordValid: _isPasswordValid,
      loginPressed: _login,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
