import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/repository/interfaces/firestore_repository.dart';

import '../services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceImpl implements FirestoreService {
  //get collections of transaction
  final CollectionReference transaction =
      FirebaseFirestore.instance.collection('transaction');
  final appState = GetIt.instance<AppStateManager>();

  final _firestoreRepository = GetIt.instance<FirestoreRepository>();

  @override
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      appState.showHomePage();
    }
    return firebaseApp;
  }

  @override
  Future<void> addtransaction(
      String name,
      String type,
      Timestamp date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount) {
    return _firestoreRepository.addtransaction(name, type, date, clothesCount,
        underpantsCount, brasCount, socksCount, othersCount, totalCount);
  }

  @override
  Stream<QuerySnapshot> getTransactionStream(
      Timestamp startDate, Timestamp endDate, bool hideCompleted) {
    return _firestoreRepository.getTransactionStream(
        startDate, endDate, hideCompleted);
  }

  @override
  Stream<QuerySnapshot> searchStream(String searchString) {
    return _firestoreRepository.searchStream(searchString);
  }

  // UPDATE: update transactions
  @override
  Future<void> updatetransaction(
    String docID,
    int status,
    String step,
    String totalCount, {
    String? selectedShelf,
    int? packCount,
  }) {
    if (status != 3) {
      return _firestoreRepository.updatetransaction(
          docID, status, step, totalCount);
    }
    return _firestoreRepository.updatetransaction(
        docID, status, step, totalCount,
        selectedShelf: selectedShelf, packCount: packCount);
  }

  @override
  Future<void> forceUpdate(
    String docID,
    int status,
    String step,
    int clothesCount,
    int underpantsCount,
    int brasCount,
    int socksCount,
    int othersCount,
    String totalCount,
    int bypass, {
    String? selectedShelf,
    int? packCount,
  }) {
    if (status != 3) {
      return _firestoreRepository.forceUpdate(
          docID,
          status,
          step,
          clothesCount,
          underpantsCount,
          brasCount,
          socksCount,
          othersCount,
          totalCount,
          bypass);
    }
    return _firestoreRepository.forceUpdate(docID, status, step, clothesCount,
        underpantsCount, brasCount, socksCount, othersCount, totalCount, bypass,
        packCount: packCount, selectedShelf: selectedShelf);
  }

  @override
  Future<void> updatetransactionIncorrectInput(String docID, int attempt) {
    return _firestoreRepository.updatetransactionIncorrectInput(docID, attempt);
  }

  @override
  Future<void> updateShelfInfo(
      String docID, String selectedShelf, int packCount) {
    return _firestoreRepository.updateShelfInfo(
        docID, selectedShelf, packCount);
  }

  @override
  Future<void> updateDatePicked(String docID, Timestamp datePicked) {
    return _firestoreRepository.updateDatePicked(docID, datePicked);
  }

  @override
  Future<void> delete(String docID) {
    return _firestoreRepository.delete(docID);
  }
}
