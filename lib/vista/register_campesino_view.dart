import 'package:ecosecha/controlador/campesino_controller.dart';
import 'package:flutter/material.dart';

class RegisterCampesinoView extends StatefulWidget {
  const RegisterCampesinoView({super.key});

  @override
  State<RegisterCampesinoView> createState() => _RegisterCampesinoViewState();
}

class _RegisterCampesinoViewState extends State<RegisterCampesinoView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfController = TextEditingController();

  final photo = Container(
    width: 200.0,
    height: 260.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/ecosecha_logo.png"))),
  );

  final comment = Container(
    width: double.infinity, // Ancho máximo
    padding:
        const EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
    child: const Align(
      alignment: Alignment.centerLeft, // Alineación izquierda
      child: Text(
        "Bienvenido al registro de campesinos de Ecosecha.",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Registro de experto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            photo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.020),
            comment,
            SizedBox(height: MediaQuery.of(context).size.height * 0.030),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: telefonoController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Telefono',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: direccionController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Direccion',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Contraseña',
                    border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: passwordConfController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Confirmar contraseña',
                    border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
            ElevatedButton(
              onPressed: () {
                registerCompany(
                  nombreController.text,
                  telefonoController.text,
                  emailController.text,
                  direccionController.text,
                  passwordController.text,
                  passwordConfController.text,
                  context,
                );
              },
              child: const Text('Registrarse'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
          ],
        ),
      ),
    );
  }
}