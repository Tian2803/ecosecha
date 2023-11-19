// ignore_for_file: use_key_in_widget_constructors

import 'package:ecosecha/controlador/login_controller.dart';
import 'package:ecosecha/controlador/usuario_controller.dart';
import 'package:ecosecha/vista/producto_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewUser extends StatefulWidget {
  const HomeViewUser({Key? key});

  @override
  State<HomeViewUser> createState() => _HomeViewUserState();
}

class _HomeViewUserState extends State<HomeViewUser> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: FutureBuilder<String?>(
                future: getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('Usuario no autenticado o sin nombre.');
                  } else {
                    final userName = snapshot.data;
                    return Text(
                      '$userName',
                      style: const TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
              accountEmail: Text(
                "$email",
                style: const TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fondo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text("Pedidos"),
              /*onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactarExperto()));
              }*/
            ),
            Expanded(child: Container()),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Cerrar sesión"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginController(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _openDrawer();
          },
        ),
        title: const Text("Productos agrícolas"),
      ),
      body: const ProductoItems(),
    );
  }
}
