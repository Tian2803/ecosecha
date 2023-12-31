import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/controlador/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfController = TextEditingController();

  bool isPasswordValid = true;
  bool isconfirmPasswordValid = true;
  bool isValidEmail = true;
  bool isValidPhoneNumber = true;

  void _validatePassword(String password) {
    setState(() {
      isPasswordValid = checkPasswordRequirements(password);
    });
  }

  void _validatePassword2(String passwordConf) {
    setState(() {
      isconfirmPasswordValid = checkPasswordRequirements(passwordConf);
    });
  }

  final photo = Container(
    width: 200.0,
    height: 260.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/ecosecha_logo.png"))),
  );

  final comment = Container(
    width: double.infinity, // Ancho máximo
    padding:
        const EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
    child: const Align(
      alignment: Alignment.centerLeft, // Alineación izquierda
      child: Text(
        "Bienvenido al registro de Ecosecha",
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
        title: const Text('Registro de usuario'),
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[ a-zA-Z]')),
                ],
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: TextField(
                controller: direccionController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home_work),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: 'Direccion',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Wrap(
                children: [
                  TextField(
                    controller: telefonoController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (value) {
                      setState(() {
                        isValidPhoneNumber = isPhoneNumberValid(value);
                      });
                    },
                  ),
                  if (!isValidPhoneNumber)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Número inválido. Debe contener 10 números.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Wrap(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        isValidEmail = AuthController.validateEmail(value);
                      });
                    },
                  ),
                  if (!isValidEmail)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Email ingresado no es válido',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextField(
                    controller: passwordController,
                    onChanged: _validatePassword,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  if (!isPasswordValid)
                    const Padding(
                      padding: EdgeInsets.all(
                          8), // Ajusta el margen del mensaje de error
                      child: Text(
                        'Contraseña no válida, debe contener al menos 10 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 15, width: widthDevice),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextField(
                    controller: passwordConfController,
                    onChanged: _validatePassword2,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: 'Confirmar contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  if (!isconfirmPasswordValid)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Contraseña no válida, debe contener al menos 10 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
            ElevatedButton(
              onPressed: () {
                registerPropietario(
                    context,
                    nombreController.text,
                    direccionController.text,
                    telefonoController.text,
                    emailController.text,
                    passwordController.text,
                    passwordConfController.text);
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
