import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/services/services.dart';

class HomeViewModel extends BaseViewModel {
  // firestore
  static final firestoreService = GetIt.instance.get<FirestoreService>();
  static final notificationService = GetIt.instance.get<NotificationService>();

  User? user;

  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;

  void initialize() async {
    user = FirebaseAuth.instance.currentUser;

    DateTime startDate = DateTime.now().subtract(const Duration(days: 4));

    await updateDate(
        DateTime(startDate.year, startDate.month, startDate.day, 0, 0),
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            23, 59));
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    notifyListeners();
  }

  Future<void> bookCourt(String courtId) async {}

  Future updateDate(DateTime startDate, DateTime endDate) async {
    _selectedStartDate = startDate;
    _selectedEndDate = endDate;
  }
}
