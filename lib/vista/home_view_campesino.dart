// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:ecosecha/controlador/campesino_controller.dart';
import 'package:ecosecha/controlador/producto_controller.dart';
import 'package:ecosecha/controlador/login_controller.dart';
import 'package:ecosecha/logica/producto.dart';
import 'package:ecosecha/vista/image_load_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewCompany extends StatefulWidget {
  const HomeViewCompany({Key? key});

  @override
  State<HomeViewCompany> createState() => _HomeViewCompanyState();
}

class _HomeViewCompanyState extends State<HomeViewCompany> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }
  
  final email = FirebaseAuth.instance.currentUser!.email;
  final user = Container(
    margin: const EdgeInsets.only(top: 30.0, bottom: 20),
    width: 100.0,
    height: 100.0,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://th.bing.com/th/id/OIP.EvZTZb4KMBsXT4RiH5DVpgHaE8?pid=ImgDet&w=474&h=316&rs=1"))),
  );

  final signOut = Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    color: const Color.fromARGB(209, 127, 206, 243),
    child: const Text(
      "Cerrar sesion",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
  //Aqui va la  hoja de
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey, // Asignamos la clave al Scaffold
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String?>(
              future: getUserNameCampesino(),
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
                  width: 90, // Ajusta el ancho según tus necesidades
                  height: 90, // Ajusta la altura según tus necesidades
                  fit: BoxFit
                      .cover, // Ajusta la forma en que la imagen se adapta al círculo
                ),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/fondo.png"),
                    fit: BoxFit.cover)),
          ),
          const ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text("Pedidos"),
              /*onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactarExperto()));
              }*/),
          Expanded(child: Container()),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Cerrar sesion"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginController()),
              );
            },
          )
        ],
      )),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _openDrawer();
            },
          ),
          title: const Text("Productos")),
      body: ListView(
        children: [
          FutureBuilder<List<Producto>>(
            future: getProductoDetails(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Transform.scale(
                    scale: 0.7,
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final productos = snapshot.data;
                if (productos != null && productos.isNotEmpty) {
                  return Column(
                    children: productos.map((producto) {
                      return ExpansionTile(
                        leading: const Icon(Icons.restaurant),
                        title:
                            Text("Nombre: ${producto.producto}"),
                        subtitle: Text("Cantidad: ${producto.cantidad}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                /*await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          productoEditController(
                                            producto: producto,
                                          )),
                                );*/
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                deleteProducto(producto);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Text("Descripcion: ${producto.descripcion}"),
                            subtitle: Text("Precio: ${producto.precio}"),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No se encontraron comidas.');
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Agrega la funcionalidad para el botón flotante aquí.
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PhotoUpload()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
