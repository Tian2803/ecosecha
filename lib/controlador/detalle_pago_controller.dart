// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:ecosecha/controlador/campesino_controller.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/controlador/producto_controller.dart';
import 'package:ecosecha/logica/detalle_pago.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void registrarDetalle(
    BuildContext context,
    String productoId,
    String campesinoId,
    String cantidad,
    String pago // Include imageUrl parameter
    ) async {
  try {
    String idDetallePago = generateId();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    DetallePago detallePago = DetallePago(
        idDetallePago: idDetallePago,
        productoId: productoId,
        campesinoId: campesinoId,
        userId: uid,
        cantidad: cantidad,
        pago: pago,
        fecha: getFechaActual());

    await FirebaseFirestore.instance
        .collection('detallePago')
        .doc(idDetallePago)
        .set(detallePago.toJson());

    print('Pago exitoso');
  } catch (e) {
    showPersonalizedAlert(
        context, 'Error al registrar la Food', AlertMessageType.error);
  }
}

Future<List<DetallePago>> getDetallePagoUsuario(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    String? campesinoId = await getCampesinoId();
    // Inicializa una lista para almacenar los detalles de pago
    List<DetallePago> detallePago = [];

    if (id != campesinoId) {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore
          .collection('detallePago')
          .where('userId', isEqualTo: id)
          .get();

      // Recorre los documentos y crea instancias de la clase DetallePago
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Obtener el nombre del producto
        String nombreProducto = await getNombreProducto(doc['productoId']);

        detallePago.add(DetallePago(
          idDetallePago: doc['idDetallePago'],
          productoId: nombreProducto,
          campesinoId: doc['campesinoId'],
          userId: doc['userId'],
          cantidad: doc['cantidad'],
          pago: doc['pago'],
          fecha: doc['fecha'],
        ));
      }
    } else {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore
          .collection('detallePago')
          .where('campesinoId', isEqualTo: id)
          .get();

      // Recorre los documentos y crea instancias de la clase DetallePago
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Obtener el nombre del producto
        String nombreProducto = await getNombreProducto(doc['productoId']);

        detallePago.add(DetallePago(
          idDetallePago: doc['idDetallePago'],
          productoId: nombreProducto,
          campesinoId: doc['campesinoId'],
          userId: doc['userId'],
          cantidad: doc['cantidad'],
          pago: doc['pago'],
          fecha: doc['fecha'],
        ));
      }
    }

    // Devuelve la lista de detalles de pago
    return detallePago;
  } catch (e) {
    // Maneja errores de forma adecuada
    print(
        'Error, no se logró obtener la información de los detalles de pago: $e');
    throw Exception(
        'No se pudo obtener la información de los detalles de pago.');
  }
}
