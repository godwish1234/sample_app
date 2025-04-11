import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class DateHelpers {
  static convertStringToDateToTimestamp(String date) {
    return Timestamp.fromDate(convertStringToDate(date));
  }

  static convertDateToTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }

  static convertStringToDate(String date) {
    return DateFormat('dd/MM/yyyy HH:mm').parse(date);
  }

  static convertTimestampToDate(Timestamp date) {
    return date.toDate();
  }

  static convertTimestampToDateToString(Timestamp date) {
    return convertDateToStringHourly(date.toDate());
  }

  static convertDateToString(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static convertDateToStringHourly(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static convertDateToStringTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
