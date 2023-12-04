// ignore_for_file: use_key_in_widget_constructors

import 'package:ecosecha/controlador/detalle_pago_controller.dart';
import 'package:ecosecha/logica/detalle_pago.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetallePagoItems extends StatelessWidget {
  DetallePagoItems();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Add any other app bar customization as needed
      ),
      body: FutureBuilder<List<DetallePago>>(
        future: getDetallePagoUsuario(uid),
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
            // Obtener la lista de detalles
            List<DetallePago>? detalle = snapshot.data;

            // Ordenar la lista por fecha en orden descendente
            detalle?.sort((a, b) => b.fecha.compareTo(a.fecha));

            if (detalle != null && detalle.isNotEmpty) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  child: Column(
                    children: [
                      for (int i = 0; i < detalle.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: 400,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 30,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Producto: ${detalle[i].productoId}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Cantidad: ${detalle[i].cantidad}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        'Total pago: \$${detalle[i].pago}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        'Fecha: ${detalle[i].fecha}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }
}
