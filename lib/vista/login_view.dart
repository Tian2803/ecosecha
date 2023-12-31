// ignore_for_file: use_key_in_widget_constructors
import 'package:ecosecha/vista/register_campesino_view.dart';
import 'package:ecosecha/vista/register_user_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isEmailValid;
  final bool isPasswordValid;
  final VoidCallback loginPressed;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.loginPressed,
  });

  final photo = Container(
    margin: const EdgeInsets.only(
      top: 40.0,
    ),
    width: 222.0,
    height: 280.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/ecosecha_logo.png"))),
  );

  final comment = const Text(
    "Bienvenido a Ecosecha",
    textAlign: TextAlign.justify,
    style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
  );

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            photo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            comment,
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: 'Correo electrónico',
                  border: const OutlineInputBorder(),
                  errorText:
                      isEmailValid ? null : 'Correo electrónico inválido',
                ),
                keyboardType:
                    TextInputType.emailAddress, // Tipo de teclado para email
              ),
            ),
            SizedBox(height: 30, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Contraseña',
                    errorText: isPasswordValid ? null : 'Contraseña inválida',
                    border: const OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.050),
            ElevatedButton(
              onPressed: loginPressed,
              child: const Text('Iniciar sesión'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Alineación de los botones y espacio entre ellos
              children: <Widget>[
                const Text("¿No tienes cuenta? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterUserView()));
                  },
                  child: const Text(
                    "Crear",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Alineación de los botones y espacio entre ellos
              children: <Widget>[
                const Text("Si eres un campesino presiona "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegisterCampesinoView()));
                  },
                  child: const Text(
                    "aqui",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
