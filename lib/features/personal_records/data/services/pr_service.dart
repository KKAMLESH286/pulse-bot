import 'package:cloud_firestore/cloud_firestore.dart';

class PRService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _prsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('prs');

  Stream<QuerySnapshot> prsStream(String userId) => _prsRef(userId).snapshots();
}
