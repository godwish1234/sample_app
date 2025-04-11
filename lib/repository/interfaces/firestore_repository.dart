import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreRepository {
  Future<void> addtransaction(
      String name,
      String type,
      Timestamp date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount);
  Stream<QuerySnapshot> getTransactionStream(
      Timestamp startDate, Timestamp endDate, bool hideCompleted);
  Stream<QuerySnapshot> searchStream(String searchString);
  Future<void> updatetransaction(
    String docID,
    int status,
    String step,
    String totalCount, {
    String? selectedShelf,
    int? packCount,
  });
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
  });
  Future<void> updatetransactionIncorrectInput(String docID, int attempt);
  Future<void> updateShelfInfo(
      String docID, String selectedShelf, int packCount);
  Future<void> updateDatePicked(String docID, Timestamp datePicked);
  Future<void> delete(String docID);
}
