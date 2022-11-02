import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato/utils/logger.dart';

class UserService {
  Future firestoreTest() async {
    FirebaseFirestore.instance
        .collection('TESTING_COLLECTION')
        .add({'testing': 'testing value', 'number': 12345});
  }

  void firestoreReadTest() {
    FirebaseFirestore.instance
        .collection('TESTING_COLLECTION')
        .doc('8affnOPzV1iYRZ61DQIu')
        .get().then((DocumentSnapshot<Map<String, dynamic>> value) => logger.d(value.data()));
  }
}
