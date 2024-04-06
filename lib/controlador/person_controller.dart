import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonController {
  Future<List<String>> getUserName() async {
    try {
      List<String> info = [];

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('usuario')
          .doc(uid)
          .get();

      if (customerSnapshot.exists) {
        info.add(customerSnapshot.data()?['name'] ?? '');
        info.add(customerSnapshot.data()?['lastName'] ?? '');
        info.add(customerSnapshot.data()?['profileImage'] ?? '');
      } else {
        final ownerSnapshot = await FirebaseFirestore.instance
            .collection('campesino')
            .doc(uid)
            .get();
        if (ownerSnapshot.exists) {
          info.add(ownerSnapshot.data()?['name'] ?? '');
          info.add(ownerSnapshot.data()?['lastName'] ?? '');
          info.add(ownerSnapshot.data()?['profileImage'] ?? '');
        }
      }

      return info;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }

  Future<List<String>> getProfileData() async {
    try {
      List<String> info = [];

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('usuario')
          .doc(uid)
          .get();

      if (userSnapshot.exists) {
        info.add(userSnapshot.data()?['name'] ?? '');
        info.add(userSnapshot.data()?['lastName'] ?? '');
        info.add(userSnapshot.data()?['phone'] ?? '');
        info.add(userSnapshot.data()?['email'] ?? '');
        info.add(userSnapshot.data()?['address'] ?? '');
        info.add(userSnapshot.data()?['profileImage'] ?? '');
      } else {
        final farmerSnapshot = await FirebaseFirestore.instance
            .collection('campesino')
            .doc(uid)
            .get();
        if (farmerSnapshot.exists) {
          info.add(farmerSnapshot.data()?['name'] ?? '');
          info.add(farmerSnapshot.data()?['lastName'] ?? '');
          info.add(farmerSnapshot.data()?['phone'] ?? '');
          info.add(farmerSnapshot.data()?['email'] ?? '');
          info.add(farmerSnapshot.data()?['address'] ?? '');
          info.add(farmerSnapshot.data()?['profileImage'] ?? '');
        }
      }

      return info;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }
}
